# # Only execute this file once per shell.
if set -q __ETC_PROFILE_NIX_SOURCED; and return; end
set __ETC_PROFILE_NIX_SOURCED 1

set -x NIX_PROFILES "/nix/var/nix/profiles/default $HOME/.nix-profile"

# Set $NIX_SSL_CERT_FILE so that Nixpkgs applications like curl work.
if set -q NIX_SSL_CERT_FILE
    : # Allow users to override the NIX_SSL_CERT_FILE
elif test -e /etc/ssl/certs/ca-certificates.crt # NixOS, Ubuntu, Debian, Gentoo, Arch
    set -x NIX_SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
elif test -e /etc/ssl/ca-bundle.pem # openSUSE Tumbleweed
    set -x NIX_SSL_CERT_FILE /etc/ssl/ca-bundle.pem
elif test -e /etc/ssl/certs/ca-bundle.crt # Old NixOS
    set -x NIX_SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt
elif test -e /etc/pki/tls/certs/ca-bundle.crt # Fedora, CentOS
    set -x NIX_SSL_CERT_FILE /etc/pki/tls/certs/ca-bundle.crt
else
  # Fall back to what is in the nix profiles, favouring whatever is defined last.
  function check_nix_profiles
    if test -n "$ZSH_VERSION"
      # Zsh by default doesn't split words in unquoted parameter expansion.
      # Set local_options for these options to be reverted at the end of the function
      # and shwordsplit to force splitting words in $NIX_PROFILES below.
      setopt local_options shwordsplit
    end
    for i in $NIX_PROFILES
      if test -e "$i/etc/ssl/certs/ca-bundle.crt"
        set -x NIX_SSL_CERT_FILE $i/etc/ssl/certs/ca-bundle.crt
      end
    end
  end
  check_nix_profiles
  set -e check_nix_profiles
end

set -x PATH "$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"
