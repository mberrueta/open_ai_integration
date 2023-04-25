# Open Ai Integration

## Installation

```sh
git clone of course
cd me

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

```sh
cd /tmp
mkdir playground
cd playground

echo "
elixir 1.14.3-otp-25
erlang 25.2.3
" > .tool-versions
asdf install
yes | mix phx.new simple_test
cd simple_test
git init
git add .
git commit -am "init repo"
mix phx.gen.live Accounts User users name:string

# the `test/simple_test_web/live/user_live_test.exs` has test for index and show
# Lets create one for show only, now the magic

```