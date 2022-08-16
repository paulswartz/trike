ARG BUILD_IMAGE=paulswartz/windows-elixir:1.13.4-erlang-24.3.4.2-windows-1809
ARG FROM_IMAGE=mcr.microsoft.com/windows/servercore:1809

FROM $BUILD_IMAGE as build

ENV MIX_ENV=dev

# log which version of Windows we're using
RUN ver

USER ContainerAdministrator
RUN curl -fSLo Git-Install.exe https://github.com/git-for-windows/git/releases/download/v2.37.1.windows.1/Git-2.37.1-64-bit.exe && \
    .\Git-Install.exe /VERYSILENT /NORESTART /NOCANCEL

USER ContainerUser

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mkdir C:\trike

WORKDIR C:\\trike

COPY mix.exs mix.lock ./
RUN mix deps.get

COPY config/config.exs config\\config.exs
COPY config/dev.exs config\\dev.exs

RUN mix deps.compile

COPY lib lib
COPY config/runtime.exs config\\runtime.exs
RUN mix release

FROM $FROM_IMAGE

USER ContainerAdministrator
RUN curl -fSLo C:\vc_redist.x64.exe https://aka.ms/vs/17/release/vc_redist.x64.exe \
    && .\vc_redist.x64.exe /install /quiet /norestart \
    && del vc_redist.x64.exe

COPY --from=build C:\\trike\\_build\\dev\\rel\\trike C:\\trike

WORKDIR C:\\trike

# Ensure Erlang can run
RUN dir && \
    erts-12.3.2.2\bin\erl -noshell -noinput +V

EXPOSE 8001
CMD ["C:\\trike\\bin\\trike.bat", "start"]
