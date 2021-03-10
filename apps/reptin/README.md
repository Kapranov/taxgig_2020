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
iex> rethinkdb-import -c taxgig.com:28015 -f foia_extract.csv --force --format csv --table ptin.ptins --fields LAST_NAME,First_NAME,BUS_ST_CODE,BUS_ADDR_ZIP,PROFESSION
iex> table("ptins") |> count |> Reptin.Database.run
%RethinkDB.Record{data: 672649, profile: nil}
iex> table("ptins") |> filter(%{"BUS_ADDR_ZIP": "33602", "First_NAME": "Steven", LAST_NAME: "Walk"}) |> Reptin.Database.run
%RethinkDB.Feed{
  data: [
    %{
      "BUS_ADDR_ZIP" => "33602",
      "BUS_ST_CODE" => "FL",
      "First_NAME" => "Steven",
      "LAST_NAME" => "Walk",
      "PROFESSION" => "ATTY,CPA",
      "id" => "00d97ecf-0f57-4adb-a6f9-e64f642ad235"
    }
  ],
  note: [],
  pid: Reptin.Database,
  profile: nil,
  token: <<10, 0, 0, 0, 0, 0, 0, 0>>
}

iex> table("ptins") |> filter(%{"BUS_ADDR_ZIP": "02125", "First_NAME": "Tara", LAST_NAME: "Allen"}) |> Reptin.Database.run
r.db('ptin').table('ptins').run(conn, callback)

%RethinkDB.Feed{
  data: [
    %{
      "BUS_ADDR_ZIP" => "02125",
      "BUS_ST_CODE" => "MA",
      "First_NAME" => "Tara",
      "LAST_NAME" => "Allen",
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
console> r.db('ptin').table('ptins').filter({"BUS_ADDR_ZIP": "33602", "First_NAME": "Steven", LAST_NAME: "Walk"})
console> r.db('ptin').table('ptins').filter({"BUS_ADDR_ZIP": "33155", "First_NAME": r.expr("GUSTAVO").downcase(), LAST_NAME: r.expr("mata").downcase()})
console> r.db("ptin").table("ptins").update({"First_name": r.row("First_name").downcase()})
console> r.db("ptin").table("ptins").update({"First_name": r.downcase(r.row["First_name"])})
r.table('moviesUnique').filter(r.row('votes').lt(100000)).min('rank')

r.db("ptin").table("users").filter(r.row["First_name"]).downcase().update()
```

#### 5 March 2021 by Oleg G.Kapranov

 [1]: http://taxgig.com:8080/
 [2]: https://rethinkdb.com/docs/quickstart/
 [3]: https://rethinkdb.com/docs/start-on-startup/
 [4]: https://blog.programster.org/rethinkdb-import-data
 [5]: https://rethinkdb.com/docs/importing/
 [6]: https://rethinkdb.com/api/ruby/connect/
 [7]: https://rethinkdb.com/api/javascript/count/
 [8]: https://rethinkdb.com/api/javascript/filter
 [9]: https://hexdocs.pm/rethinkdb/extra-api-reference.html
[10]: https://github.com/hamiltop/rethinkdb-elixir
[11]: https://github.com/hamiltop/rethinkdb-elixir
[12]: https://github.com/hamiltop/rethinkdb-elixir/wiki/Ten-minute-guide-with-RethinkDB-Elixir
[13]: https://github.com/et/collaborative-editor
[14]: https://github.com/hamiltop/friends-demo
[15]: https://github.com/azukiapp/elixir-rethinkdb
[16]: https://github.com/hamiltop/rethinkdb-elixir
[17]: https://stackoverflow.com/questions/31457945/how-to-use-rethinkdb-with-phoenixframework
[18]: https://www.compose.com/articles/connecting-to-rethinkdb-with-elixir/
