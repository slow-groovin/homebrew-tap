class TerminalAichat < Formula
  desc "A cli for AI/LLM chat in terminal. Extremely simple and easy to use. Using OpenAI-compatible `/v1/chat/completion` API"
  homepage "https://github.com/slow-groovin/terminal-aichat"
  version "1.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/slow-groovin/terminal-aichat/releases/download/v1.0.4/terminal-aichat-aarch64-apple-darwin.tar.xz"
      sha256 "1146f771049ec551c89f4d8a714b5694c37c03c96bbd29548422a22ec5513e50"
    end
    if Hardware::CPU.intel?
      url "https://github.com/slow-groovin/terminal-aichat/releases/download/v1.0.4/terminal-aichat-x86_64-apple-darwin.tar.xz"
      sha256 "bd405c2034b149ba2b14b5197e915be009e247a3914bfe4d7f96f28e5fbf47f9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/slow-groovin/terminal-aichat/releases/download/v1.0.4/terminal-aichat-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "470dcce7ab00bac888dc3435469b9181bff80138f325da42bf9745a3acca4f8b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/slow-groovin/terminal-aichat/releases/download/v1.0.4/terminal-aichat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "60d2c606ba543e4f53d8c33306811153ae8bb367b6783a31d8fbe17d7c8aec7f"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "aichat" if OS.mac? && Hardware::CPU.arm?
    bin.install "aichat" if OS.mac? && Hardware::CPU.intel?
    bin.install "aichat" if OS.linux? && Hardware::CPU.arm?
    bin.install "aichat" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
