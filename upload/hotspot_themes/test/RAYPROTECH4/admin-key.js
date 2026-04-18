function validateToken(keyString){
	var encrypted = CryptoJS.AES.encrypt(keyString, "Secret Passphrase");
	var decrypted = CryptoJS.AES.decrypt(encrypted, "Secret Passphrase").toString(CryptoJS.enc.Utf8);
	var encryptedKey = "U2FsdGVkX18P84JqLG1pE0IWp+BTEX7KL80xvr/ozSg=";
	var decryptedKey = CryptoJS.AES.decrypt(encryptedKey, "Secret Passphrase").toString(CryptoJS.enc.Utf8);
	
	if(decrypted==decryptedKey)
	{
		document.getElementById("_0xb262x3").style.display = "block";
	}
	
}









