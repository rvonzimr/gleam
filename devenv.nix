{
  pkgs,
  lib,
  config,
  _inputs,
  ...
}:
let
  db_user = "postgres";
  db_name = "db";

in
{

  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.gleam
    pkgs.rebar3
    pkgs.erlang_28
    pkgs.nodejs
    pkgs.tailwindcss-language-server
    pkgs.tailwindcss_4
    pkgs.dbmate
    pkgs.package-version-server
    pkgs.postgres-lsp
    pkgs.bun
    pkgs.nixd
    pkgs.nil
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    pkgs.inotify-tools
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    pkgs.libiconv
  ];

  languages.gleam.enable = true;
  dotenv.enable = true;
  dotenv.filename = [ ".env.local" ];

  services.postgres = {
    enable = true;
    initialScript = ''
      CREATE USER ${db_user} WITH SUPERUSER PASSWORD 'postgres';
      CREATE ROLE billuc;
      CREATE USER billuc WITH PASSWORD 'password' LOGIN ROLE billuc;
    '';
    listen_addresses = "localhost";
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
      exec = "gleam run -m cigogne new $1";
      cwd = "${config.git.root}/server";
    };

    "db:all" = {
      exec = "gleam run -m cigogne all";
      cwd = "${config.git.root}/server";
      before = [ "devenv:processes:server" ];
    };

    "db:down" = {
      exec = "gleam run -m cignone down";
      cwd = "${config.git.root}/server";
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
    };
  };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

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
}
