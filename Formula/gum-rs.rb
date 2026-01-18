class GumRs < Formula
  desc "Super fast git multiple user config manager. A Rust remake of https://github.com/gauseen/gum"
  homepage "https://github.com/slow-groovin/gum-rs"
  version "0.0.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/slow-groovin/gum-rs/releases/download/v0.0.6/gum-rs-aarch64-apple-darwin.tar.xz"
      sha256 "7bafb6a5692f5e4f3d7d5c6edd11f77e8ac513e9644b7a36f134f6db6857632c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/slow-groovin/gum-rs/releases/download/v0.0.6/gum-rs-x86_64-apple-darwin.tar.xz"
      sha256 "e2e2e0625562e8275e5cc089c83bcb37e5386773eca5f5260480aef363b2972f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/slow-groovin/gum-rs/releases/download/v0.0.6/gum-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2c8d7b011b0233f4e8a1661eb6c272bce87decbcb67f54c57db827733b2d4f5c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/slow-groovin/gum-rs/releases/download/v0.0.6/gum-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "62dd4b1061ac9f1128a9da1e0a5c3c702cb65d6011a279086c8ed64e1dee3394"
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
    bin.install "gum" if OS.mac? && Hardware::CPU.arm?
    bin.install "gum" if OS.mac? && Hardware::CPU.intel?
    bin.install "gum" if OS.linux? && Hardware::CPU.arm?
    bin.install "gum" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
