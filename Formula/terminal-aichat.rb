class TerminalAichat < Formula
  desc "A cli for AI/LLM chat in terminal. Extremely simple and easy to use. Using OpenAI-compatible `/v1/chat/completion` API"
  homepage "https://github.com/slow-groovin/terminal-aichat"
  version "1.0.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/slow-groovin/terminal-aichat/releases/download/v1.0.5/terminal-aichat-aarch64-apple-darwin.tar.xz"
      sha256 "e177a06616dc11c929de22fae7dc76abafaffdb221cbb5b82663076a0ae76c1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/slow-groovin/terminal-aichat/releases/download/v1.0.5/terminal-aichat-x86_64-apple-darwin.tar.xz"
      sha256 "4d36bf890e860810b1c7b003dd57e062aad84e9be375ba99548ad4bea9458734"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/slow-groovin/terminal-aichat/releases/download/v1.0.5/terminal-aichat-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4c7942968609950e8d340d3627e343bf45a0f2a62da2e28fc3835359a257c175"
    end
    if Hardware::CPU.intel?
      url "https://github.com/slow-groovin/terminal-aichat/releases/download/v1.0.5/terminal-aichat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7fb796bd0e1e5cb2a3f60e5d0bf925ce9f06181ed2bf84634da71a245006315a"
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
