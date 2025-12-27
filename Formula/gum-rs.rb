class GumRs < Formula
  desc "Super fast git multiple user config manager. A Rust remake of https://github.com/gauseen/gum"
  homepage "https://github.com/slow-groovin/gum-rs"
  version "0.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/slow-groovin/gum-rs/releases/download/v0.0.3/gum-rs-aarch64-apple-darwin.tar.xz"
      sha256 "f829b5f3eefbe16b0e1ff3cd539a5864192531f2436b556bcc547ce4b5412510"
    end
    if Hardware::CPU.intel?
      url "https://github.com/slow-groovin/gum-rs/releases/download/v0.0.3/gum-rs-x86_64-apple-darwin.tar.xz"
      sha256 "a2368fea6fc7a87ce33d304081b9ebe050ab6556b5c6ae6e3c2928e8b13e17fd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/slow-groovin/gum-rs/releases/download/v0.0.3/gum-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8df131b53233fa8821deb9d86899efb67015d09e53796595067b6ef805765676"
    end
    if Hardware::CPU.intel?
      url "https://github.com/slow-groovin/gum-rs/releases/download/v0.0.3/gum-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4f1234cd6b249c269718e1c98bcb27af2fb7c80bbfd458f98b02ce6689d54ebf"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "gum-rs" if OS.mac? && Hardware::CPU.arm?
    bin.install "gum-rs" if OS.mac? && Hardware::CPU.intel?
    bin.install "gum-rs" if OS.linux? && Hardware::CPU.arm?
    bin.install "gum-rs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
