---
layout: post
title: Tor circuits to onion services using stem and Python
date: 2023-09-12 08:00:00 -0400
featured_image: /images/Tor-logo.png
preview_image: Tor-logo.png
---


### Introduction
TODO: give brief introduction of tor and my research

During my research project, I studied the feasibility of launching traffic correlation attacks in the Tor network. These attacks were disregarded in the original Tor paper [1], since it was assumed that the adversary would need an unrealistic coverage to be able to observe a large part of the Tor network. Recently, advances in machine learning have motivated traffic correlation attacks like DeepCorr [2] and DeepCoFFEA [3]. So, we decided to study the probability of Tor clients to select a guard node in a given country when establishing circuits.


### Analyzing guard relay distribution
For this, we used Stem's Python Tor controller library. With Stem, we can attach to a running Tor's controller, create new circuits, inspect all the data pertaining the relays in the circuits, change guard nodes, amongst others. 

1. Create torrc file in data/torrc
```{bash}
ControlPort 9051
CookieAuthentication 1
CookieAuthFileGroupReadable 1
# Force guard change
UseEntryGuards 0
```

2. Start Tor client process
```{python}
import subprocess
import shlex
import time
import traceback
import joblib
import logging
import logging.config
logging.config.dictConfig({
    'version': 1,
    'disable_existing_loggers': True,
})

command = "/opt/homebrew/opt/tor/bin/tor -f data/torrc"
tor_process = subprocess.Popen(shlex.split(command))
time.sleep(10)
logging.debug("Wait for Tor process to start ...")
```

3. Attach to the running controller and force the creation of a new circuit
```{python}
SOCKS_PORT = 9050
CONTROL_PORT = 9051

with Controller.from_port(address="127.0.0.1", port=CONTROL_PORT) as controller:
    controller.authenticate(password="")
    logging.debug("Successfully authenticated with Tor control port")

    logging.debug(f"Created {len(controller.get_circuits())} preemptive circuits")

    try:
        # TODO
    except Exception as e:
        logging.error(f"create_new_circuit_and_close() failed after 10 attempts. Continuing ...")

```

4. Define the creation of a new circuit:
```{python}
guard_nodes = {}

@retry(wait_exponential_multiplier=1000, wait_exponential_max=10000, stop_max_attempt_number=10)
def create_new_circuit_and_close(controller):
    logging.debug(f"RETRY create_new_circuit()")

    circuit_id = controller.new_circuit(await_build=True, timeout=60)
    circuit = controller.get_circuits()[-1]

    guard_ip, middle_ip, exit_ip = get_circuit_data(controller, circuit)
    
    try:
        country = get_geolocation(guard_ip)
        if ip in guard_nodes:
            guard_nodes[ip]['count'] += 1
        else:
            guard_nodes[ip]['country'] = country
    except RelayGeolocationException as e:
        traceback.print_exc()
        sys.exit(0)

    controller.close_circuit(circuit_id)
```

5. Get data on circuit relays from Tor descriptors:
```{python}
def get_circuit_data(controller, circuit):
    guard_ip, middle_ip, exit_ip = None, None, None

    if circuit.status == CircStatus.BUILT and len(circuit.path) >=3:
        guard_fingerprint = circuit.path[0][0]  # 
        middle_fingerprint = circuit.path[1][0]
        exit_fingerprint = circuit.path[2][0]

        # Get relay details for each hop
        guard_relay = controller.get_network_status(guard_fingerprint)
        middle_relay = controller.get_network_status(middle_fingerprint)
        exit_relay = controller.get_network_status(exit_fingerprint)

    else:
        logging.debug("Circuit skipped")

    return guard_relay.address, middle_relay.address, exit_relay.address
```

6. Get relays country from their IP:
```{python}
class RelayGeolocationException(Exception):
    def __init__(self, message):
        super().__init__(message)

def get_geolocation(ip_address):
    url = f"http://ip-api.com/json/{ip_address}" # Limited by 45 requests per minute
    response = requests.get(url)
    if response.status_code != 200:
        raise RelayGeolocationException(f"Could not fetch geolocation for {ip_address} due to {response.status_code} error")
    data = response.json()

    return data['country_code']
```

7. Gather data for a great number of clients and stop the Tor process:
```{python}
BASE_DIR = './results/data/'
GUARD_NODES_FILE = f"{BASE_DIR}client_guard_nodes.joblib"
MIDDLE_NODES_FILE = f"{BASE_DIR}client_middle_nodes.joblib"
EXIT_NODES_FILE = f"{BASE_DIR}client_exit_nodes.joblib"

def stop_tor(tor_process):
    tor_process.terminate()
    tor_process.wait()  # Wait for the process to finish

try:
    num_clients = 10000
    for client_id in tqdm(range(num_clients)):
        generate_client_circuits(client_id)
        time.sleep(10)

        # Updates on every iteration
        joblib.dump(guard_nodes, GUARD_NODES_FILE)
        joblib.dump(middle_nodes, MIDDLE_NODES_FILE)
        joblib.dump(exit_nodes, EXIT_NODES_FILE)

except Exception as e:
    traceback.print_exc()

finally:
    stop_tor(tor_process)
    logging.debug("Wait for Tor process to stop ...")
    time.sleep(10)
    logging.debug("Exited Tor process cleanly at the end")
```

### Guard Coverage Visualization
Now that we retrieved a lot of data on the country where Tor guard relays are located, we will determine the guard probability by country.

1. Setup necessary libraries and collected data:
```{python}
import geopandas
import pycountry
import pandas as pd
import numpy as np
import matplotlib.colors as mcolors

guard_nodes = joblib.load(GUARD_NODES_FILE)
```

2. 
```{python}
def convert_alpha2_to_alpha3_country_code(alpha2_code):
    country = pycountry.countries.get(alpha_2=alpha2_code)
    if country:
        return country.alpha_3
    return None

def get_country_codes_count_df():
    df = pd.DataFrame(list(country_codes_count.items()), columns=['code', 'guards_count'])
    df['code'] = df['code'].apply(convert_alpha2_to_alpha3_country_code)
    return df

country_codes_count_df = get_country_codes_count_df()

total_occurrences = country_codes_count_df['guards_count'].sum()
country_codes_count_df['guards_probability'] = country_codes_count_df['guards_count'] / total_occurrences
```

3. 
```{python}

```






| Name                     | Guards probability   | Cumulative guards probability   |
|:-------------------------|:---------------------|:--------------------------------|
| Germany                  | 30.0%                | 30.0%                           |
| United States of America | 24.75%               | 54.75%                          |
| Finland                  | 5.97%                | 60.72%                          |
| Canada                   | 4.09%                | 64.81%                          |
| Netherlands              | 4.07%                | 68.88%                          |
| Poland                   | 3.49%                | 72.37%                          |
| United Kingdom           | 3.35%                | 75.72%                          |
| Switzerland              | 2.62%                | 78.34%                          |
| Sweden                   | 2.08%                | 80.42%                          |
| Czechia                  | 1.63%                | 82.05%                          |



[1] Roger Dingledine, Nick Mathewson, and Paul Syverson. 2004. Tor: the second-generation onion router. In Proceedings of the 13th conference on USENIX Security Symposium - Volume 13 (SSYM'04). USENIX Association, USA, 21.

[2] Milad Nasr, Alireza Bahramali, and Amir Houmansadr. 2018. DeepCorr: Strong Flow Correlation Attacks on Tor Using Deep Learning. In Proceedings of the 2018 ACM SIGSAC Conference on Computer and Communications Security (CCS '18). Association for Computing Machinery, New York, NY, USA, 1962–1976. https://doi.org/10.1145/3243734.3243824

[3] Se Eun Oh, Taiji Yang, Nate Mathews, James K Holland, Mohammad Saidur Rahman, Nicholas Hopper, and Matthew Wright, DeepCoFFEA: Improved Flow Correlation Attacks on Tor via Metric Learning and Amplification. 2022 IEEE Symposium on Security and Privacy (SP '22), San Francisco, CA, USA, 2022, pp. 1915-1932, https://doi.org/10.1109/SP46214.2022.9833801.