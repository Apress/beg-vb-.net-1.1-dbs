<%@ Page Language="vb" AutoEventWireup="false" Codebehind="WebForm1.aspx.vb" Inherits="WebDataValidation.WebForm1"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
   <HEAD>
      <title>WebForm1</title>
      <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
      <meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
      <meta content="JavaScript" name="vs_defaultClientScript">
      <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
   </HEAD>
   <body>
      <script language="javascript">
         function validate_photoformat(oSrc, args)
         {
            args.IsValid = false;
            if(args.Value)
            {
               var length = args.Value.length;
               var endsWith = args.Value.substr(length - 3, 3);
               if(endsWith == "jpg")
               {
                  args.IsValid = true;
               }
            }
         }
      </script>
      <form id="Form1" method="post" runat="server">
         <P>First Name :
            <asp:textbox id="FirstNameTextBox" runat="server"></asp:textbox>
            <asp:requiredfieldvalidator id="FirstNameRequiredFieldValidator" runat="server" ErrorMessage="First Name Is Required"
               ControlToValidate="FirstNameTextBox"></asp:requiredfieldvalidator></P>
         <P>Hire Date :
            <asp:textbox id="HireDateTextBox" runat="server"></asp:textbox><asp:rangevalidator id="HireDateValidator" runat="server" ErrorMessage="The hire date must be within one week of today's date"
               ControlToValidate="HireDateTextBox" Type="Date" Display="Dynamic"></asp:rangevalidator>&nbsp;
            <asp:requiredfieldvalidator id="HireDateRequiredFieldValidator" runat="server" ErrorMessage="Hire Date is required"
               ControlToValidate="HireDateTextBox"></asp:requiredfieldvalidator></P>
         <P>Password :
            <asp:textbox id="PasswordTextBox" runat="server" TextMode="Password"></asp:textbox></P>
         <P>Confirm Password :
            <asp:TextBox id="ConfirmPasswordTextBox" runat="server" TextMode="Password"></asp:TextBox>
            <asp:CompareValidator id="PasswordCompareValidator" runat="server" ErrorMessage="Passwords do not match"
               ControlToValidate="ConfirmPasswordTextBox" ControlToCompare="PasswordTextBox"></asp:CompareValidator></P>
         <P>Photo URL :
            <asp:TextBox id="PhotoUrlTextBox" runat="server"></asp:TextBox>
            <asp:RegularExpressionValidator id="PhotoUrlRegularExpressionValidator" runat="server" ErrorMessage="This is not a valid URL"
               ControlToValidate="PhotoUrlTextBox" ValidationExpression="http://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?"></asp:RegularExpressionValidator>&nbsp;
            <asp:CustomValidator id="PhotoUrlCustomValidator" runat="server" ErrorMessage="Unsupported file format"
               ControlToValidate="PhotoUrlTextBox" ClientValidationFunction="validate_photoformat"></asp:CustomValidator></P>
         <P>
            <asp:Button id="SubmitButton" runat="server" Text="Submit"></asp:Button>
            <asp:Button id="CancelButton" runat="server" Text="Cancel" CausesValidation="False"></asp:Button></P>
      </form>
   </body>
</HTML>
