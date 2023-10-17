public with sharing class VantivPostResponse {
	public class vantivResponseException extends Exception{}
	public String transactionId;
	public String legalEntityId;
	public String subMerchantId;
	public String responseCode;
	public String responseDescription;
	public String responseAsString;
	public String merchantIdentString;
	public String payPageId;
	Public String notes;
	public Boolean isSuccess = false;
	public Boolean isDuplicate = false;
	public List<String> errors = new List<String>();
	
	public void parse(HttpResponse response)
	{
		if(response == null)
		{
			System.debug(response);
			throw new vantivResponseException('An empty response was received');
		}
		Dom.Document doc = response.getBodyDocument();
		Dom.XmlNode node = doc.getRootElement();
		if('errorResponse'.equalsIgnoreCase(node.getName()))
		{
			isSuccess = false;
			parseAllErrors(node);
		}
		else
		{
			for(Dom.XmlNode n :node.getChildElements())
			{
				isSuccess = true;
				String name = n.getName();
				
				if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) 
				{
					if(node.getAttribute('duplicate',null) != null)
					{
						isDuplicate = Boolean.valueOf(node.getAttribute('duplicate',null));
						//depends on how business wants to handle this scenario
						//parseLegalEntityForDuplicate(node);
					}
				}
				if('transactionId'.equalsIgnoreCase(name))
				{
					this.transactionId = n.getText();
				}
				else if('legalEntityId'.equalsIgnoreCase(name))
				{
					this.legalEntityId = n.getText();
				}
				else if('responseCode'.equalsIgnoreCase(name))
				{
					this.responseCode = n.getText();
				}
				else if('responseDescription'.equalsIgnoreCase(name))
				{
					this.responseDescription = n.getText();
				}
				else if('subMerchantId'.equalsIgnoreCase(name))
				{
					this.subMerchantId = n.getText();
				}
				else if('merchantIdentString'.equalsIgnoreCase(name))
				{
					this.merchantIdentString = n.getText();
				}
				else if('paypageCredentials'.equalsIgnoreCase(name))
				{
					parsePayPageCredentials(n);
				}
				else if('backgroundCheckResults'.equalsIgnoreCase(name))
				{
					parseNotes(n);
				}
				
			}
			
		}
		this.responseAsString = doc.toXmlString();
	}
	
	private void parseAllErrors(Dom.XmlNode node)
	{
		for(Dom.xmlNode n : node.getChildElements())
		{
			String name = n.getName();
			if('transactionId'.equalsIgnoreCase(name))
			{
				this.transactionId = n.getText();
			}
			else if('errors'.equalsIgnoreCase(name))
			{
				for(Dom.XmlNode n2 : n.getChildElements())
				{
					this.errors.add(n2.getText());
				}
			}
			
		}
	}
	/*
	* This methos is used to read the original legal entity if
	* any specific details are required to be shown.
	*/
	/*private void parseLegalEntityForDuplicate(Dom.XmlNode node)
	{
		for(Dom.XmlNode n :node.getChildElements())
		{
			String name = n.getName();
			if('originalLegalEntity'.equalsIgnoreCase(name))
			{
				for(Dom.XmlNode n2 : n.getChildElements())
				{
					if('legalEntityId'.equalsIgnoreCase(n2.getName()))
					{
						this.legalEntityId = n2.getText();
					}
				}
			}
				
		}
	}*/
	private void parsePayPageCredentials(Dom.xmlNode node)
	{
		for(Dom.XmlNode n :node.getChildElements())
		{
			if('paypageCredential'.equalsIgnoreCase(n.getName()))
			{
				for(Dom.XmlNode n2 :n.getChildElements())
				{
					String name = n2.getName();
					if('paypageId'.equalsIgnoreCase(name))
					{
						this.payPageId = n2.getText();
					}
				}
				break;
			}
		}
	}
	
	private void parseNotes(Dom.xmlNode node)
	{
		for(Dom.xmlNode n: node.getChildElements())
		{
			if('backgroundCheckDecisionNotes'.equalsIgnoreCase(n.getName()))
			{
				this.notes = n.getText();
			}
		}
	}
	
	public override string toString()
	{
		return 'Transaction Id: '+ transactionId+
			   '\n Legal Entity Id: '+ legalEntityId+
			   '\n Sub-Merchant Id: '+ subMerchantId+
			   '\n Response Code: '+ responseCode+
			   '\n Response Description: '+ responseDescription+
			   '\n Raw Response : \n'+ responseAsString;
	}

	

}