# Shuttle One Token (SZO)
    - Standard ERC20
    - 18 decimals
    - token_price represents the starting sale price that will be issued from the smart contract
	Only the Owner of the Smart Contract can adjust the token price in the smart contract
	The token price has a min floor price of 0.0004Eth per SZO
	
# Issuance of Token

ShuttleOne's Money Protocol requires KYC onchain through the ShuttleOne app. Only KYCed verified and approved users are able to transact.
	The KYC data will be encrypted from client and stored on the blockchain, however only ShuttleOne is able to decrypt the KYC data to reveal the KYC details usually for law enforcement work.


The SZO token is priced to the ethereum gasnetwork gwei. Every SZO is backed by eth thats locked in the smart contract, only a ShuttleOne user with the KYCed owner can unlock eth during a transaction initiated by the user to pay for gas.


# Token Burning 

Total token supply in this contract is 138mil SZO, there's a 5% inflation per year after the issuance of all the tokens. The inflation conditions will only intiate after all tokens are issued and tied to minting conditions:
	1. Opening of ShuttleOne wallets
	2. Unique KYC verified onchain
	3. Top up of wallet is done

ShuttleOne calculates profits as token_price minus tokenRedeem with the excess in digital assets sent to a custody of ShuttleOne that would be used during extreme price volatility of eth or SZO prices and firstRedemption event.
internalTransfer from wallet to wallet (i.e kyced users) is barred. This is administrator control level.




# Token Generation & General Metrics

96.8mil SZO will be preminted and locked for 12months. This is distributed to the early team members, equity holders and genesis users (users who participated in our pilot tests).
The tokens locked cannot be transfered out during the lockUP period or transacted.
Tokens under this premint will not be used for fee but redemption from ShuttleOne which we will utilize firstRedemption. ShuttleOne thereafter burns all the SZO.
