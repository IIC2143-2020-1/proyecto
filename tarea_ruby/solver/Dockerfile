FROM ruby:2.7.1-slim-buster
WORKDIR /src

# Set language as C.UTF-8
ENV LANG C.UTF-8

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Run as non-root user
RUN useradd -m fakeuser && chown -R fakeuser: .
USER fakeuser

# Start the main process.
CMD ["/bin/bash", "./solver.sh"]
