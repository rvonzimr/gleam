{
  pkgs,
  _lib,
  config,
  _inputs,
  ...
}:
let
  db_user = "postgres";
  db_name = "db";

in
{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.gleam
    pkgs.rebar3
    pkgs.erlang_28
    pkgs.nodejs
    pkgs.tailwindcss-language-server
    pkgs.tailwindcss_4
    pkgs.inotify-tools
    pkgs.dbmate
    pkgs.package-version-server
    pkgs.postgres-lsp
  ];

  languages.gleam.enable = true;
  dotenv.enable = true;
  dotenv.filename = [ ".env.local" ];

  processes = {
    client = {
      exec = "gleam run -m lustre/dev start";
      cwd = "${config.git.root}/client";
    };

    server = {
      exec = "gleam dev";
      cwd = "${config.git.root}/server";
      process-compose.depends_on.postgres.condition = "process_healthy";
    };
  };

  services.postgres = {
    enable = true;
    initialScript = ''
      CREATE USER ${db_user} WITH_PASSWORD postgres;
    '';
    initialDatabases = [ { name = db_name; } ];
  };

  # https://devenv.sh/tasks/
  tasks = {
    "client:build" = {
      exec = "gleam build";
      execIfModified = [
        "client/**/*"
      ];
      cwd = "${config.git.root}/client";
    };

    "server:build" = {
      exec = "gleam build";
      execIfModified = [
        "server/**/*"
      ];
      cwd = "${config.git.root}/server";
    };

    "client:test" = {
      exec = "gleam test";
      cwd = "${config.git.root}/client";
    };

    "server:test" = {
      exec = "gleam test";
      cwd = "${config.git.root}/server";
    };

    "db:new" = {
      exec = "dbmate new $1";
    };

    "db:up" = {
      exec = "dbmate up";
    };

    "db:down" = {
      exec = "dbmate down";
    };

    "db:dump" = {
      exec = "dbmate dump";
    };

    "db:squirrel" = {
      exec = "gleam run -m squirrel";
      execIfModified = [
        "server/src/sql/**/*"
        "db/**/*"
      ];
      cwd = "${config.git.root}/server";
      before = [ "db:up" ];
    };
  };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
