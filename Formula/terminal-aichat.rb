class TerminalAichat < Formula
  desc "A cli for AI/LLM chat in terminal. Extremely simple and easy to use. Using OpenAI-compatible `/v1/chat/completion` API"
  homepage "https://github.com/slow-groovin/terminal-aichat"
  version "1.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/slow-groovin/terminal-aichat/releases/download/v1.0.3/terminal-aichat-aarch64-apple-darwin.tar.xz"
      sha256 "ac9851ad11801f56a7ee1b2cf88208273852f0604eda7e8b449ae1d3ffa27dbd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/slow-groovin/terminal-aichat/releases/download/v1.0.3/terminal-aichat-x86_64-apple-darwin.tar.xz"
      sha256 "323eef65a85e572894c7faab45d8bd7054e4d30bb04bc6cfd5137446c86bc4b5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/slow-groovin/terminal-aichat/releases/download/v1.0.3/terminal-aichat-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ccc4d2dea8fe237579c4770efab08dea081a6e61e70c6002ca5f06065b219465"
    end
    if Hardware::CPU.intel?
      url "https://github.com/slow-groovin/terminal-aichat/releases/download/v1.0.3/terminal-aichat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "69a3286a295dbfc3ef583b58d56f1e3aea4f1ef18a40def29cd84234c6c9cf5b"
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
