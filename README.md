# ElixirJobs

## Exercise 01

Run command
```
  bash ./calculate_jobs_table.sh

  +---------------------------------------------------------------------------------------------------------+
  |                                         Available jobs overview                                         |
  +---------------+-------+-------+----------+---------+------+-------------------+--------+------+---------+
  |               | Total | Admin | Business | Conseil | Créa | Marketing / Comm' | Retail | Tech | Unknown |
  +---------------+-------+-------+----------+---------+------+-------------------+--------+------+---------+
  | Total         | 5069  | 411   | 1445     | 175     | 212  | 782               | 536    | 1439 | 69      |
  | Africa        | 9     | 1     | 3        | 0       | 0    | 1                 | 1      | 3    | 0       |
  | Antarctica    | 0     | 0     | 0        | 0       | 0    | 0                 | 0      | 0    | 0       |
  | Asia          | 52    | 1     | 30       | 0       | 0    | 3                 | 7      | 11   | 0       |
  | Australia     | 1     | 0     | 0        | 0       | 0    | 0                 | 1      | 0    | 0       |
  | Europe        | 4787  | 394   | 1368     | 175     | 205  | 759               | 425    | 1401 | 60      |
  | North America | 147   | 9     | 25       | 0       | 7    | 12                | 80     | 13   | 1       |
  | Oceania       | 8     | 0     | 0        | 0       | 0    | 1                 | 7      | 0    | 0       |
  | South America | 5     | 0     | 4        | 0       | 0    | 0                 | 0      | 1    | 0       |
  | Unknown       | 60    | 6     | 15       | 0       | 0    | 6                 | 15     | 10   | 8       |
  +---------------+-------+-------+----------+---------+------+-------------------+--------+------+---------+
```

---

## Exercise 02  

In order for this data to be updated in real time, we need to store it in-memory and implement the minimum required API for interacting with the state.  
If we use Elixir/Erlang we might use GenServer to store JobsStats state.

JobsStats API:
- Update whole state
- Increment spicific job counter
- Get stats
- Subscribe to state updates

So on server startup we prepare initial stats and ``Update whole state`` once. Than on new job create we get it's location and send JobsStats service a message to ``Increment specific job counter``. And everytime we need JobsStats, we can use ``Get Stats``. If we need it we can use pub/sub to listen for JobsStats updates in real-time.

Furthermore, my conjecture is that:
- It might be a good idea to use Rust NIF for GeoCalculations (need to be tested)
- It also might be a good idea to use Rust NIF to make mutable HashMap to update stats faster (need to be tested)


---
## Exercise 03
### Start with:
```
  mix run --no-halt
```

### API
- ``/`` - Welcome page
- ``/jobs`` - Jobs page with query params requred
  - Query Params:
    - ``latitude`` [deg] any number
    - ``longitude`` [deg] any number
    - ``radius`` [km] must be > 0
  - Example: ``/jobs?latitude=0&longitude=0&radius=1``
