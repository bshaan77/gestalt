# frozen_string_literal: true

class Gestalt < Formula
  desc "CLI for Gestalt API - authentication, integration management, and operation invocation"
  homepage "https://github.com/valon-technologies/gestalt"
  version "0.0.2-alpha.21"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/valon-technologies/gestalt/releases/download/gestalt/v0.0.2-alpha.21/gestalt-macos-arm64.tar.gz"
      sha256 "fdfbeec7e5c2e51fd9b811056f42006349973b57549dab1da5f4d00ffdb80797"
    end

    on_intel do
      url "https://github.com/valon-technologies/gestalt/releases/download/gestalt/v0.0.2-alpha.21/gestalt-macos-x86_64.tar.gz"
      sha256 "efe4983725f141b0be1e8ec7aa19ca27ed762ba9eb65021eebb7e90da8a68652"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/valon-technologies/gestalt/releases/download/gestalt/v0.0.2-alpha.21/gestalt-linux-arm64.tar.gz"
      sha256 "01e23b224eaeb6c9aa2925fe55b3e8cce7801f3e1d4db0bde6a81dae2e7a7fc9"
    end

    on_intel do
      url "https://github.com/valon-technologies/gestalt/releases/download/gestalt/v0.0.2-alpha.21/gestalt-linux-x86_64.tar.gz"
      sha256 "c6b87c9a5e9f07971762d23d63a9e1730b0b667b3115c8f09ac6387bc05a196f"
    end
  end

  def install
    bin.install "gestalt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gestalt --version")
  end
end
