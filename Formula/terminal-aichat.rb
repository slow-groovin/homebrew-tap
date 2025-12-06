class TerminalAichat < Formula
  desc "A terminal AI/LLM chat tool. Extremely simple and easy to use. Using OpenAI-compatible `/v1/chat/completion` API"
  homepage "https://github.com/slow-groovin/terminal-aichat"
  version "0.3.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/slow-groovin/terminal-aichat/releases/download/v0.3.4/terminal-aichat-aarch64-apple-darwin.tar.xz"
      sha256 "849b3e183380b5be08ea437e865b836674669b6cf10833f69413d44cc4068e82"
    end
    if Hardware::CPU.intel?
      url "https://github.com/slow-groovin/terminal-aichat/releases/download/v0.3.4/terminal-aichat-x86_64-apple-darwin.tar.xz"
      sha256 "c545ad019dae290811777a9a8e6b2b02b716987d2800da9ef2d0622de97d59d2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/slow-groovin/terminal-aichat/releases/download/v0.3.4/terminal-aichat-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0d42afea188116e3c02593aa9964a6c05322eaef4f0bd741da9714b2f43853d9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/slow-groovin/terminal-aichat/releases/download/v0.3.4/terminal-aichat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f15160b7e2f12277ee3a17702550537a7a17e6149d05d7dbe9e872bbecf8b20e"
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
