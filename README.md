# Open Ai Integration

## Installation

```sh
git clone git@github.com:mberrueta/open_ai_integration.git
cd open_ai_integration
PATH_TO_OPEN_AI_INT=$(pwd)

asdf install
direnv allow

# create an API Key
open "https://platform.openai.com/account/api-keys"
echo " export API_KEY= " > .envrc.custom

# and add there
direnv allow
```

## Running

### Elixir

new terminal (no env vars yet)

```sh

cd /tmp
mkdir playground
cd playground

echo "
elixir 1.14.3-otp-25
erlang 25.2.3
ruby 3.2.2
" > .tool-versions
asdf install
yes | mix phx.new simple_test
cd simple_test
mix phx.gen.live Accounts User users name:string
# * creating lib/simple_test_web/live/user_live/show.ex
# ...
echo "
/_build
/deps
/assets/vendor
.envrc.custom
" >  ".gitignore"

git init
git status
git add .

git commit -am "init repo"

```


The `test/simple_test_web/live/user_live_test.exs` has test for index and show
Lets create one for show only, now the magic

```sh
# First we need the env var setup
cp $PATH_TO_OPEN_AI_INT/.envrc .
cp $PATH_TO_OPEN_AI_INT/.envrc.custom . # <- WARNING !!! DON'T COMMIT THIS FILE, HAS THE API_KEY
git status

direnv allow
ruby $PATH_TO_OPEN_AI_INT/generate_test.rb -p ./lib/simple_test_web/live/user_live/show.ex

cat ./test/lib/simple_test_web/live/user_live/show_test.exs
# cool ne?
```