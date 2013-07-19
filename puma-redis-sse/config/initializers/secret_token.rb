# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
PumaRedisSse::Application.config.secret_key_base = '35bd92f6eaa447f102224d9c6e49097b50c8b4a7b86db833e93215af87d6c4296da8cc21e6cbe19b887bac9fe017e71a81f19ab6a219b26ed486215830d5ccc2'
