# TaxgigEx

**TODO: Add description**

```
bash> git clone https://gitlab.com/taxgig/taxgig_ex.git
bash> cd taxgig_ex
bash> touch README.md
bash> git add README.md
bash> git commit -m "created empty dir"
bash> git push -u origin master

bash> git commit --amend -m "fixed last a git commit message"
bash> git push --force origin master

bash> mix new ./ --app taxgig_ex --umbrella

bash> mix docs

bash> make git-"YOUR TEXT"
```

```
bash> cd apps
bash> mix new mailings
bash> mix new core --sup
bash> mix new ptin --sup
bash> mix new stripe --sup
bash> mix new blockscore --sup
bash> mix phx.new server --no-html --no-webpack --no-ecto
```

```
bash> curl -X POST -H "Content-Type: application/json" --data '{ "query": "{ allMatchValueRelates { id } }" }' http://taxgig.me:4000/graphiql | jq .
bash> curl -X POST -H "Content-Type: application/json" --data '{ "query": "{ allMatchValueRelates { id } }" }' http://taxgig.me:4000/api | jq .
bash> curl -X POST -H "Content-Type: application/json" --data '{ "query": "{ allLanguages { id abbr name inserted_at updated_at} }" }' http://taxgig.me:4000/api | jq .

bash> curl -k -X POST -H "Content-Type: application/json" --data '{ "query": "{ allLanguages { id abbr name inserted_at updated_at} }" }' https://taxgig.me:4001/api | jq .
bash> curl -k \\
           -X POST \\
           -H "Content-Type: application/json" \\
           -F query="mutation { uploadPicture(file: \"my_file\", name: \"logo\", alt:\"curl example\", profileId: \"9uqHdgI0URR5OKC8DQ\")}" \\
           -F my_file=@logo.png \\
           https://taxgig.me:4001/api | jq .
```

#### Backend API

**umbrella app name**: `taxgig_ex`

##### umbrella apps:
- [X] `blockscore` - queries blockscore backend to verify users
- [X] `core` - contains all DB models, migrations and manipulation functions
- [X] `mailings` - sends emails to users
- [X] `ptin` - keeps and updates DB of all PTIN holders
- [X] `server` - resolvers, schemas GraphQL
- [X] `stripe` - functions to handle stripe

#### Frontend
- [] React MVC

### Fix build source

1. `apps/chat` - `entropy_string/mix.ex` - in `def package: xref: [exclude: :crypto]`

### 20 Jan 2020 by Oleg G.Kapranov

[1]: https://gitlab.com/taxgig/taxgig_ex
[2]: https://paper.dropbox.com/doc/Graph-API--AsyYKWDkl3ycVg1z40YLkKukAg-FNst2XVqeQQW5HBCs0JKH
[3]: https://paper.dropbox.com/doc/Backend-Tech-Documentation-UOhiP5AhK7PsJBJ5ZVKJo
[4]: https://paper.dropbox.com/doc/Backend-API-Documentation-FNst2XVqeQQW5HBCs0JKH
[5]: https://github.com/phoenixframework/phoenix/tree/v1.4.0/installer/templates/phx_umbrella
