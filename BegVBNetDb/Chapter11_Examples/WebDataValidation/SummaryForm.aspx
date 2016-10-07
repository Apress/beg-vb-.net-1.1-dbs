<%@ Page Language="vb" AutoEventWireup="false" Codebehind="SummaryForm.aspx.vb" Inherits="WebDataValidation.SummaryForm"%>
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
         <table cellspacing="1" cellpadding="5" border="1" borderColor="black">
            <TR>
               <TD colSpan="3" rowSpan="1" borderColor="black" bgColor="#339966">
                  <P align="center"><EM><STRONG><FONT color="#ffffff">New Employee Form</FONT></STRONG></EM></P>
               </TD>
            </TR>
            <tr>
               <td>
                  <P>First Name :
                     <asp:textbox id="FirstNameTextBox" runat="server"></asp:textbox>
                     <asp:requiredfieldvalidator id="FirstNameRequiredFieldValidator" runat="server" ControlToValidate="FirstNameTextBox"
                        ErrorMessage="First Name Is Required">*</asp:requiredfieldvalidator></P>
               </td>
               <td>Last Name :
                  <asp:TextBox id="LastNameTextBox" runat="server"></asp:TextBox>
                  <asp:RequiredFieldValidator id="LastNameRequiredFieldValidator" runat="server" ErrorMessage="Last Name Is Required"
                     ControlToValidate="LastNameTextBox">*</asp:RequiredFieldValidator></td>
               <TD rowspan="3">
                  <asp:ValidationSummary id="EmployeeValidationSummary" runat="server" DisplayMode="List"></asp:ValidationSummary>
                  <asp:Label id="DataErrorMessage" runat="server"></asp:Label></TD>
            </tr>
            <tr>
               <td>
                  <P>Hire Date :
                     <asp:textbox id="HireDateTextBox" runat="server"></asp:textbox>
                     <asp:rangevalidator id="HireDateValidator" runat="server" ControlToValidate="HireDateTextBox" ErrorMessage="The hire date must be within one week of today's date"
                        Type="Date">*</asp:rangevalidator>
                     <asp:requiredfieldvalidator id="HireDateRequiredFieldValidator" runat="server" ControlToValidate="HireDateTextBox"
                        ErrorMessage="Hire Date is required">*</asp:requiredfieldvalidator></P>
               </td>
               <td>
                  <P>Birth&nbsp;Date :
                     <asp:textbox id="BirthDateTextBox" runat="server"></asp:textbox>
                     <asp:rangevalidator id="BirthDateValidator" runat="server" ControlToValidate="BirthDateTextBox" ErrorMessage="The hire date must be within one week of today's date"
                        Type="Date">*</asp:rangevalidator>
                     <asp:requiredfieldvalidator id="BirthDateRequiredFieldValidator" runat="server" ControlToValidate="BirthDateTextBox"
                        ErrorMessage="Birth Date is required">*</asp:requiredfieldvalidator></P>
               </td>
            </tr>
            <tr>
               <td>Reports To : &nbsp;
                  <asp:DropDownList id="ReportsToDropDownList" runat="server"></asp:DropDownList></td>
               <td>Photo URL :
                  <asp:TextBox id="PhotoUrlTextBox" runat="server"></asp:TextBox>
                  <asp:RegularExpressionValidator id="PhotoUrlRegularExpressionValidator" runat="server" ControlToValidate="PhotoUrlTextBox"
                     ErrorMessage="This is not a valid URL" ValidationExpression="http://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?">*</asp:RegularExpressionValidator>&nbsp;</td>
            </tr>
            <TR>
               <TD colSpan="3">
                  <P align="center">
                     <asp:Button id="SubmitButton" runat="server" Text="Submit"></asp:Button>
                     <asp:Button id="ClearButton" runat="server" Text="Clear" CausesValidation="False"></asp:Button></P>
               </TD>
            </TR>
         </table>
         <P>&nbsp;</P>
         <P>&nbsp;</P>
      </form>
   </body>
</HTML>
