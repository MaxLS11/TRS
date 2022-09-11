
import React, { useState } from 'react';

export default function Mint(props) {

	const [assetURIs, setAssetURIs] = useState([]);
	const CheckAssetURIs = async () => {
		let uris = [];

		for(let idx = 1; idx <= 4; idx++ ){
			let uri = '/token_data/exobit_'+idx+'.json';
			let tokenId = await props.contract.methods.tokenByUri(uri).call();
			if(tokenId === "0") uris.push(uri);
		}

		if(uris.length) setAssetURIs([...uris]);
	}

	const DoMint = async (tokenURI) => {
		console.log('minting: ', tokenURI);
		try{
      
			let gasLimit = await props.contract.methods.CustomMint(tokenURI).estimateGas(
				{ 
					from: props.address, 
					value: 100000000000000
				}
			);
      
			let result = await props.contract.methods.CustomMint(tokenURI)
				.send({ 
					from: props.address, 
					value: 100000000000000,
				
					gasLimit: gasLimit
				});

			console.log('result', result);

      CheckAssetURIs();

		}catch(e){
			console.error('There was a problem while minting', e);
		}
	};

	if(!props.contract) return (<div className="page error">Contract Not Available</div>);

	if(!assetURIs.length) CheckAssetURIs();

	return (
		<div className="page mint">
			<h2>Click on an image to mint a token</h2>
			{assetURIs.map((uri, idx) => (
					<div onClick={() => DoMint(uri)} key={idx}>
						<img src={uri.replace('.json', '.png')} alt={'exobit_'+(idx+1)} />
					</div>
				)
			)}
		</div>
	);
}
