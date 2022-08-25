# Reptin

```
iex> import RethinkDB.Query
iex> db_create("ptin") |> Reptin.Database.run
%RethinkDB.Record{
  data: %{
    "config_changes" => [
      %{
        "new_val" => %{
          "id" => "a2723659-312e-42da-8c52-779c4800d12f",
          "name" => "ptin"
        }
      }
    ],
    "dbs_created" => 1
  },
  profile: nil
}

iex> table_create("expires") |> Reptin.Database.run
iex> table_create("ptins") |> Reptin.Database.run
iex> table_query = table("expires")
iex> q = insert(table_query, %{expired: "Updated February 20, 2021", url: "https://www.irs.gov/pub/irs-utl/FOIA_Hawaii_extract.csv"})
iex> Reptin.Database.run(q)
bash> rethinkdb-import -c taxgig.com:28015 -f foia_extract.csv --force --format csv --table ptin.ptins --fields last_name,first_name,bus_st_code,bus_addr_zip,profession
iex> table("ptins") |> count |> Reptin.Database.run
%RethinkDB.Record{data: 672649, profile: nil}
iex> table("ptins") |> filter(%{"bus_addr_zip": "33602", "first_name": "steven", last_name: "walk"}) |> Reptin.Database.run
%RethinkDB.Feed{
  data: [
    %{
      "bus_addr_zip" => "33602",
      "bus_st_code" => "FL",
      "first_name" => "steven",
      "last_name" => "walk",
      "profession" => "ATTY,CPA",
      "id" => "00d97ecf-0f57-4adb-a6f9-e64f642ad235"
    }
  ],
  note: [],
  pid: Reptin.Database,
  profile: nil,
  token: <<10, 0, 0, 0, 0, 0, 0, 0>>
}

iex> table("ptins") |> filter(%{"bus_addr_zip": "02125", "first_name": "tara", last_name: "allen"}) |> Reptin.Database.run
r.db('ptin').table('ptins').run(conn, callback)

%RethinkDB.Feed{
  data: [
    %{
      "bus_addr_zip" => "02125",
      "bus_st_code" => "MA",
      "first_name" => "Tara",
      "last_name" => "Allen",
      "id" => "00d96cd2-5cc5-457c-baf8-bc094bf99c8b"
    }
  ],
  note: [],
  pid: Reptin.Database,
  profile: nil,
  token: <<11, 0, 0, 0, 0, 0, 0, 0>>
}
```

```
console> r.db('ptin').table('ptins').filter({"bus_addr_zip": "33602", "first_name": "steven", last_name: "walk"})
console> r.db('ptin').table('ptins').filter({"bus_addr_zip": "33155", "first_name": r.expr("gustavo").downcase(), last_name: r.expr("mata").downcase()})
console> r.db("ptin").table("ptins").update({"first_name": r.row("first_name").downcase()})
console> r.db("ptin").table("ptins").update({"first_name": r.downcase(r.row["first_name"])})
console> r.db("ptin").table('moviesUnique').filter(r.row('votes').lt(100000)).min('rank')
console> r.db("ptin").table("users").filter(r.row["First_name"]).downcase().update()

console> r.db("ptin").table("ptins").filter({first_name: "gustavo"})
console> r.db("ptin").table("ptins").filter({last_name: "mata"})
console> r.db("ptin").table("ptins").filter({bus_addr_zip: "33155"})

console> r.db("ptin").table("ptins").replace(r.row.without('views'))
console> r.db("ptin").table("ptins").replace(function (row) {return row.without('First_NAME').merge({'first_name': row('First_NAME')})})
console> r.db("ptin").table("ptins").replace(function (row) {return row.without('LAST_NAME').merge({'last_name': row('LAST_NAME')})})
console> r.db("ptin").table("ptins").replace(function (row) {return row.without('BUS_ADDR_ZIP').merge({'bus_addr_zip': row('BUS_ADDR_ZIP')})})
console> r.db("ptin").table("ptins").replace(function (row) {return row.without('BUS_ST_CODE').merge({'bus_st_code': row('BUS_ST_CODE')})})
console> r.db("ptin").table("ptins").replace(function (row) {return row.without('PROFESSION').merge({'profession': row('PROFESSION')})})
console> r.db("ptin").table("ptins").update({LAST_NAME: r.row('LAST_NAME').downcase()}, {returnChanges: true})
console> r.db("ptin").table("ptins").update({First_NAME: r.row('First_NAME').downcase()}, {returnChanges: true})
          # old_file = path <> "/" <> name_csv
          # new_file = path <> "/" <> "new_" <> name_csv
          # System.cmd("/bin/sh", ["-c", "cat #{old_file} | awk 'NR==1{\$0=tolower(\$0)} 1' > #{new_file}"])
          # [] = :os.cmd(:"cat #{old_file} | awk 'NR==1{$0=tolower($0)} 1' > #{new_file}")
          # [] = :os.cmd(:"cat #{old_file} | awk -F"," 'BEGIN{OFS=","} {$1 = tolower($1); $2 = tolower($2); print}' > #{new_file}")
          #
          # [] = :os.cmd(:"#{exec1} #{old_file} #{new_file}")
          # [] = :os.cmd(:"#{exec2} #{new_file}")
          #
          # bin_dir = Application.get_env(:reptin, :bin_dir)
          # exec1 = bin_dir <> "/" <> "format.sh"
          # {"", 0} = System.cmd("#{exec1}", ["#{old_file}", "#{new_file}"])
          # [] = :os.cmd(:"#{exec1} #{old_file} #{new_file}")
          # exec2 = bin_dir <> "/" <> "import.sh"
          # {"", 0} = System.cmd("#{exec2}", ["#{new_file}"])
          # [] = :os.cmd(:"#{exec2} #{new_file}")
          # cat foia_extract.csv | awk 'NR==1{$0=tolower($0)} 1' | awk -F"," 'BEGIN{OFS=","} {$1 = tolower($1); $2 = tolower($2); print}' > new_foia_extract.csv
          # awk --field-separator ',' 'BEGIN{OFS=","} {$1 = tolower($1); $2 = tolower($2); print}' foia_extract.csv > new_foia_extract.csv
          # awk --field-separator , 'BEGIN{OFS=","} {$1 = tolower($1); $2 = tolower($2); print}' foia_extract.csv > new_foia_extract.csv
```

```
console> import RethinkDB.Query
console> db_list |> Reptin.Database.run
console> table_list |> Reptin.Database.run

console> RethinkDB.Query.db_list |> Reptin.Database.run
console> RethinkDB.Query.table_list |> Reptin.Database.run
console> RethinkDB.Query.table("expires") |> RethinkDB.Query.count |> Reptin.Database.run
console> RethinkDB.Query.table("ptins") |> RethinkDB.Query.count |> Reptin.Database.run
console> RethinkDB.Query.table("expires") |> RethinkDB.Query.limit(5) |> Reptin.Database.run
console> RethinkDB.Query.table("ptins") |> RethinkDB.Query.limit(5) |> Reptin.Database.run
console> RethinkDB.Query.table("expires") |> RethinkDB.Query.pluck({"id", "https://www.irs.gov/pub/irs-utl/FOIA_Extract.csv"}) |> Reptin.Database.run
console> RethinkDB.Query.table("expires") |> RethinkDB.Query.filter(%{id: "7058796e-808a-49be-8ba3-f40b4dac779d"}) |> Reptin.Database.run
console> RethinkDB.Query.table("expires") |> RethinkDB.Query.filter(%{expired: "Updated August 24, 2021"}) |> Reptin.Database.run
console> RethinkDB.Query.table("ptins") |> RethinkDB.Query.filter(%{last_name: "mata"}) |> Reptin.Database.run
console> RethinkDB.Query.table("ptins") |> RethinkDB.Query.filter(%{first_name: "oleg"}) |> Reptin.Database.run
console> RethinkDB.Query.table("ptins") |> RethinkDB.Query.filter(%{last_name: "mata"}) |> RethinkDB.Query.count |> Reptin.Database.run
```

#### 5 March 2021 by Oleg G.Kapranov

 [1]: http://taxgig.com:8080/
 [2]: https://rethinkdb.com/docs/sql-to-reql/python/
 [3]: https://rethinkdb.com/docs/quickstart/
 [4]: https://rethinkdb.com/docs/start-on-startup/
 [5]: https://blog.programster.org/rethinkdb-import-data
 [6]: https://rethinkdb.com/docs/importing/
 [7]: https://rethinkdb.com/api/ruby/connect/
 [8]: https://rethinkdb.com/api/javascript/count/
 [9]: https://rethinkdb.com/api/javascript/filter
[10]: https://hexdocs.pm/rethinkdb/extra-api-reference.html
[11]: https://github.com/hamiltop/rethinkdb-elixir
[12]: https://github.com/hamiltop/rethinkdb-elixir/wiki/Ten-minute-guide-with-RethinkDB-Elixir
[13]: https://github.com/et/collaborative-editor
[14]: https://github.com/hamiltop/friends-demo
[15]: https://github.com/azukiapp/elixir-rethinkdb
[16]: https://github.com/hamiltop/rethinkdb-elixir
[17]: https://stackoverflow.com/questions/31457945/how-to-use-rethinkdb-with-phoenixframework
[18]: https://www.compose.com/articles/connecting-to-rethinkdb-with-elixir/
