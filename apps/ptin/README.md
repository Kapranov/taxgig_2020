# Ptin

**TODO: Add description**

```
bash> mix new ptin --sup

bash> mix ecto.gen.migration -r Ptin.Repo add_uuid_generate_v4_extension_to_database
bash> mix ecto.gen.migration -r Ptin.Repo create_expires
bash> mix ecto.gen.migration -r Ptin.Repo create_ptins
```

```
bash> cd /tmp; wget "https://www.irs.gov/pub/irs-utl/FOIA_California_extract.csv" -O ./foia_california_extract.csv
psql> COPY ptins(last_name, first_name, bus_st_code, bus_addr_zip, profession) FROM '/tmp/foia_california_extract.csv' WITH DELIMITER ',' NULL as ' ' CSV HEADER;
psql> ALTER TABLE ptins ALTER COLUMN bus_addr_zip TYPE integer USING (trim(bus_addr_zip)::integer);
psql> ALTER TABLE ptins ALTER COLUMN bus_addr_zip TYPE varchar(255);
```

```
data = "/tmp/foia_california_extract.json"
struct =
  data
  |> File.read!()
  |> Jason.decode!()
  |> Enum.map(fn %{
    "LAST_NAME" => last_name,
    "First_NAME" => first_name,
    "BUS_ST_CODE" => bus_st_code,
    "BUS_ADDR_ZIP" => bus_addr_zip,
    "PROFESSION" => profession
  } -> %{
    last_name: last_name,
    first_name: first_name,
    bus_st_code: bus_st_code,
    bus_addr_zip: bus_addr_zip,
    profession: profession
  } end)
  |> Enum.map(&Map.put(&1, :id, Ecto.UUID.generate))

PtinRepo.insert_all(Ptin, struct)
```

### 21 Jan 2020 by Oleg G.Kapranov

[1]: https://www.postgresqltutorial.com/import-csv-file-into-posgresql-table/
[2]: https://csvjson.com/csv2json
[3]: https://stackoverflow.com/questions/34231532/what-is-the-limit-on-the-number-of-rows-that-can-be-inserted-in-a-single-insert
[4]: https://stackoverflow.com/questions/8347237/postgresql-copy-from-csv-with-missing-data-values
[5]: https://stackoverflow.com/questions/19034674/copy-null-values-present-in-csv-file-to-postgres
