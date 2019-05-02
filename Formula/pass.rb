class Pass < Formula
  desc "Password manager"
  homepage "https://www.passwordstore.org/"
  url "https://github.com/Fingel/password-store/archive/master.zip"
  sha256 "f9bbe0377a3228fadba98abfbccbb665943a9fc09c6d0b80075287ca00f867c9"
  head "https://github.com/Fingel/password-store", :using => :git

  depends_on "gnu-getopt"
  depends_on "gnupg"
  depends_on "qrencode"
  depends_on "tree"

  def install
    system "make", "PREFIX=#{prefix}", "WITH_ALLCOMP=yes", "BASHCOMPDIR=#{bash_completion}", "ZSHCOMPDIR=#{zsh_completion}", "FISHCOMPDIR=#{fish_completion}", "install"
    inreplace "#{bin}/pass", /^SYSTEM_EXTENSION_DIR=.*$/, "SYSTEM_EXTENSION_DIR=\"#{HOMEBREW_PREFIX}/lib/password-store/extensions\""
    elisp.install "contrib/emacs/password-store.el"
    pkgshare.install "contrib"
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      system bin/"pass", "init", "Testing"
      system bin/"pass", "generate", "Email/testing@foo.bar", "15"
      assert_predicate testpath/".password-store/Email/testing@foo.bar.gpg", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
