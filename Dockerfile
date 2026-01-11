FROM ruby:2.4.10

# Some older Debian-based images (buster) have had their mirrors moved to
# archive.debian.org. Replace upstream sources to archive if necessary and
# allow releaseinfo changes so `apt-get update` doesn't fail for EOL releases.
RUN if grep -q buster /etc/os-release 2>/dev/null; then \
    sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list || true; \
    sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list || true; \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until || true; \
    fi

# Update and install base build dependencies. Use --allow-releaseinfo-change
# as fallback when the release info has moved/changed.
RUN apt-get update -qq -o Acquire::Check-Valid-Until=false || apt-get update --allow-releaseinfo-change -qq \
    && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    curl \
    ca-certificates \
    gnupg2 \
    git \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    fontconfig \
    fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/*

# ---- Install Java (Temurin JRE 8) without apt (avoids ca-certificates-java issues) ----
ENV JAVA_HOME=/opt/java
ENV PATH="$JAVA_HOME/bin:$PATH"

RUN set -eux; \
    mkdir -p "$JAVA_HOME"; \
    curl -LfsS "https://api.adoptium.net/v3/binary/latest/8/ga/linux/x64/jre/hotspot/normal/eclipse" -o /tmp/jre8.tar.gz; \
    tar -xzf /tmp/jre8.tar.gz -C "$JAVA_HOME" --strip-components=1; \
    rm -f /tmp/jre8.tar.gz; \
    java -version

# Install Node (via NodeSource) and Yarn (official repo) for asset compilation.
RUN curl -fsSL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get update -qq -o Acquire::Check-Valid-Until=false || apt-get update --allow-releaseinfo-change -qq \
    && apt-get install -y --no-install-recommends nodejs \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq -o Acquire::Check-Valid-Until=false || apt-get update --allow-releaseinfo-change -qq \
    && apt-get install -y --no-install-recommends yarn \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Cache gems
COPY Gemfile Gemfile.lock ./
# Install the bundler version recorded in Gemfile.lock (1.15.4) so it's
# compatible with the project's Ruby 2.5 runtime.
RUN gem install bundler -v 1.15.4 && bundle _1.15.4_ install --jobs=4 --retry=3

# Copy the app
COPY . .
RUN mkdir -p /app/reports \
    && chmod -R 755 /app/reports

#ENV RAILS_ENV=development
# ===== PRODUCCIÓN =====
ENV RAILS_ENV=production
ENV RACK_ENV=production
ENV RAILS_SERVE_STATIC_FILES=1
ENV RAILS_LOG_TO_STDOUT=1

# Precompile assets (Sprockets) Produccion
RUN SECRET_KEY_BASE=123456789 bundle exec rake assets:precompile --trace

EXPOSE 3000

# IMPORTANT:
# Do NOT use 'bash -l' (login shell) or JAVA will not be found in PATH
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0 -p 3000"]
