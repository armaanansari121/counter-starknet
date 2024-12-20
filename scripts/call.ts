import { Contract, Account, RpcProvider } from "starknet";
import * as dotenv from "dotenv";
import { getCompiledCode } from "./utils";
dotenv.config();

async function getCounterValue() {
  const provider = new RpcProvider({
    nodeUrl: process.env.RPC_ENDPOINT,
  });

  const privateKey: string = process.env.DEPLOYER_PRIVATE_KEY as string; 
  const accountAddress: string = process.env.DEPLOYER_ADDRESS as string; 

  // Initialize the account
  const account = new Account(provider, accountAddress, privateKey);

  // Define the contract
  const contractAddress: string = process.env.CONTRACT_ADDRESS as string; 
  let sierraCode;

  try {
    ({ sierraCode } = await getCompiledCode(
      "workshop_counter_contract"
    ));
  } catch (error: any) {
    console.log("Failed to read contract files");
    process.exit(1);
  }
  const abi = sierraCode.abi;

  const contract = new Contract(abi, contractAddress, account);

  try {
    const counterValue = await contract.call("get_counter", []);
    console.log("Current counter value:", counterValue);
  } catch (error) {
    console.error("Error fetching counter value:", error);
  }
}

getCounterValue();
