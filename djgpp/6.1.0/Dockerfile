FROM opensuse:42.1

# Install cURL.
RUN zypper --non-interactive install --repo=OSS curl && zypper clean -a

# Install Tini and use it as the init process.
RUN curl -sLo /tini https://github.com/krallin/tini/releases/download/v0.10.0/tini \
 && chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Install DJGPP for cross-compiling DOS applications.
RUN cd /tmp \
 && curl -sOJ ftp://ftp.delorie.com/pub/djgpp/rpms/djcross-binutils-2.24-1ap.x86_64.rpm \
 && curl -sOJ ftp://ftp.delorie.com/pub/djgpp/rpms/djcrx-2.05-5.x86_64.rpm \
 && curl -sOJ http://ap1.pp.fi/djgpp/gcc/6.1.0/rpm/x86_64/djcross-gcc-6.1.0-1ap.x86_64.rpm \
 && rpm -i *.rpm \
 && rm *.rpm

# Create symbolic links (eg. gcc -> i586-pc-msdosdjgpp-gcc)
RUN for SHORT_NAME in $(find /usr/bin/ | grep -oP 'i586-pc-msdosdjgpp-\K.*'); do \
      ln -s /usr/bin/i586-pc-msdosdjgpp-$SHORT_NAME /usr/bin/$SHORT_NAME; \
    done

# Create a directory for working in. This should be used to mount a volume.
RUN mkdir /workspace
WORKDIR /workspace

# Create a non-privileged user as the default user
RUN useradd -s /bin/bash appuser \
 && chown appuser /workspace
USER appuser

CMD ["bash"]
