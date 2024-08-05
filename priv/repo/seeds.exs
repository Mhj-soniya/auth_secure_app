# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AuthSecure.Repo.insert!(%AuthSecure.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias AuthSecure.Repo
alias AuthSecure.Accounts.User

# Ensure the admin account does not already exist
unless Repo.get_by(User, email: "admin@example.com") do

  %User{}
  |> User.changeset(%{name: "admin", email: "admin@example.com", password_hash: "admin123", role: "admin"})
  |> Repo.insert!()
  IO.puts("Admin created successfully!!!")
else
  IO.puts("Admin already exists!!!")
end
