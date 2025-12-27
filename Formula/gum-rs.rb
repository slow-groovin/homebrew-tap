class GumRs < Formula
  desc "Super fast git multiple user config manager. A Rust remake of https://github.com/gauseen/gum"
  homepage "https://github.com/slow-groovin/gum-rs"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/slow-groovin/gum-rs/releases/download/v0.0.2/gum-rs-aarch64-apple-darwin.tar.xz"
      sha256 "cfa5120068bbcd7e521cad84f12fced677693a08a2caa811244e66eb97dc18ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/slow-groovin/gum-rs/releases/download/v0.0.2/gum-rs-x86_64-apple-darwin.tar.xz"
      sha256 "129eb44538ef7db7f71822e69455d326e8c4fbfec8240839d3a2c9d0d7499f40"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/slow-groovin/gum-rs/releases/download/v0.0.2/gum-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2cf66e35f8717ba33102655bdb750820013327a9b2fb86c03669ac0df0861b10"
    end
    if Hardware::CPU.intel?
      url "https://github.com/slow-groovin/gum-rs/releases/download/v0.0.2/gum-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3ed79a0ebb1241c0df96bf95812d7585f82ec5576a46a36b6511768e2cc33a00"
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
