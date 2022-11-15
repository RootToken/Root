
async function deploy(mock = true) {
  const signer = await hre.ethers.getSigner();
  if (mock) {
    await hre.network.provider.request({
      method: "hardhat_impersonateAccount",
      params: ['0xa6542Ba5588d275e2e7d0fB2b0aa295a56003B72'],
    });
    await hre.network.provider.send("hardhat_setBalance", [signer.address, "0x3635C9ADC5DEA00000"]);
  }

  let i = 0;
  while (i < 7) {
    await signer.sendTransaction({
      nonce: i,
      to: signer.address,
      gasLimit: 21000,
      value: "0",
    });
    i += 1;
  }

  const RootToken = await ethers.getContractFactory("Root", {
    signer,
  });
  this.rootToken = await upgrades.deployProxy(RootToken, ["Root", "ROOT"], {
    initializer: "initialize",
  });
  console.log("Root token deployed at: ", this.rootToken.address);

  // Transfer ownership
  const t = await this.rootToken.transferOwnership('0xb7774ec5031e1d903152E96BbC1601e5D0D83Ca2');
  await t.wait();
  console.log("New owner: ", await this.rootToken.ownerCandidate());
}

exports.deployRoot = deploy;
