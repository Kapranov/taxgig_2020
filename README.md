# TaxgigEx

**TODO: Add description**

```
bash> git clone https://gitlab.com/taxgig/taxgig_ex.git
bash> cd taxgig_ex
bash> touch README.md
bash> git add README.md
bash> git commit -m "created empty dir"
bash> git push -u origin master

bash> mix new ./ --app taxgig_ex --umbrella

bash> mix docs

bash> make git-"YOUR TEXT"
```

```
bash> cd apps
bash> mix new mailings
bash> mix new graph_web --sup
bash> mix phx.new core  --no-html --no-webpack --no-ecto
```

#### Backend API

**umbrella app name**: `taxgig`

##### umbrella apps:
- [] `blockscore` - queries blockscore backend to verify users
- [X] `core` - contains all DB models, migrations and manipulation functions
- [X] `mailings` - sends emails to users
- [] `ptin` - keeps and updates DB of all PTIN holders
- [] `stripe` - functions to handle stripe
- [] `graph_web` - resolvers, schemas GraphQL

#### Frontend
- []
- []
- []


### 20 Jan 2020 by Oleg G.Kapranov

[1]: https://gitlab.com/taxgig/taxgig_ex
[2]: https://paper.dropbox.com/doc/Graph-API--AsyYKWDkl3ycVg1z40YLkKukAg-FNst2XVqeQQW5HBCs0JKH
[3]: https://paper.dropbox.com/doc/Backend-Tech-Documentation-UOhiP5AhK7PsJBJ5ZVKJo#:h2=umbrella-apps
