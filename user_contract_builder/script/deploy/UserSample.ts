import { ethers } from "hardhat";

async function main() {

    // Note: Following addresses are dummy values. Replace them with deployed addresses.
    let relayAddress = "0xD02e33f98a08030B72A471Ae41e696a57cFecCc8";
    let usdcToken = "0xD330cF76192274bb3f10f2E574a1bDba4ED29352";
    const userSample = await ethers.deployContract(
        "UserSample",
        [
            relayAddress,
            usdcToken
        ]
    );
    await userSample.waitForDeployment();
    console.log("User Contract is deployed at ", userSample.target);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
