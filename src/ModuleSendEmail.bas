Attribute VB_Name = "ModuleSendEmail"
' Envoie un e-mail via Outlook avec un corps en texte brut ou HTML,
' un sujet, un destinataire et un fichier joint
' Vérifie si l'adresse e-mail est valide et ajuste le format du message selon le paramètre Layout
' Si DisplayEmail est False, l'e-mail est envoyé automatiquement
' sinon, il est affiché dans outlook

Function SendEmail(ByVal SendTo As String, ByVal Subject As String, _
                   ByVal Body As String, ByVal AttachmentPath As String, _
                   Optional ByVal Layout As String = "TEXT", _
                   Optional ByVal DisplayEmail As Boolean = False) As Boolean
                   
    Dim OutlookApp As Object
    Dim OutlookMail As Object
    Dim HtmlBody As String
    Dim line() As String
    
    SendTo = Trim(LCase(SendTo))
    
    If Not InStr(SendTo, "@") > 0 Then
        SendEmail = False
        Exit Function
    End If
    
    Set OutlookApp = CreateObject("Outlook.Application")
    Set OutlookMail = OutlookApp.CreateItem(0)
    
    If UCase(Layout) = "HTML" Then
        HtmlBody = _
            "<!DOCTYPE html>" & _
            "<html>" & _
            "<head>" & _
                "<meta content=""text/html; charset=UTF-8"" http-equiv=Content-Type>" & _
                "<meta name=""viewport"" content=""width=device-width, initial-scale=1.0"">" & _
                "<meta name=x-apple-disable-message-reformatting>" & _
                "<meta content=""IE=edge"" http-equiv=X-UA-Compatible>" & _
                "<title></title>" & _
                "<link href=""https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,700"" rel=stylesheet>" & _
            "</head>"
            
        HtmlBody = HtmlBody & _
            "<body style=""background-color: #FAFAFA; margin: 0; padding: 0;"">" & _
                "<table role=""presentation"" width=""100%"" cellspacing=""0"" cellpadding=""0"" border=""0"" style=""min-width: 320px;"">" & _
                    "<tr>" & _
                        "<td style=""background-color: #009790; height: 30px;""></td>" & _
                    "</tr>" & _
                    "<tr>" & _
                        "<td align=""center"" style=""padding: 30px 0;"">" & _
                            "<a href=""https://www.helha.be/"" target=""_blank"">" & _
                                "<img alt=""HELHa logo"" src=""https://intranet-test.helha.be/wp-content/uploads/2021/03/LOGO_HELHa.png"" style=""width:30vw; max-width:174px;"" title=""HELHa logo"" width=""174"">" & _
                            "</a>" & _
                        "</td>" & _
                    "</tr>" & _
                    "<tr>" & _
                        "<td align=""center"">" & _
                            "<table role=""presentation"" width=""100%"" style=""padding: 15px 10px; max-width: 600px; background-color: #FFFFFF; border: solid 1px #CACACA; font-family: 'Source Sans Pro', sans-serif; font-size: 16px; line-height:150%; color:#000000; margin-bottom: 35px;"">" & _
                                "<tr>" & _
                                    "<td>"

        line = Split(Body, vbCrLf)
        
        For i = LBound(line) To UBound(line)
            If line(i) = "" Then
                HtmlBody = HtmlBody & " <br>"
            Else
                HtmlBody = HtmlBody & "<p style=""margin:0;"">" & line(i) & "</p>"
            End If
        Next i
        
        HtmlBody = HtmlBody & _
                                    "</td>" & _
                                "</tr>" & _
                            "</table>" & _
                        "</td>" & _
                    "</tr>" & _
                    "<tr>" & _
                        "<td align=""center"" style=""background-color: #009790; padding: 20px 0; font-size: 14px; color: #FFFFFF; font-family: 'Source Sans Pro', sans-serif; text-align: center; line-height: 150%;"">" & _
                            "<p style=""margin:0;"">HELHa Mons</p>" & _
                            "<p style=""margin:0;"">Chaussée de Binche, 159, 7000 Mons</p>" & _
                            "<p style=""margin:0;"">" & _
                                "<strong><a style=""color: #FFFFFF; text-decoration: none;"" href=""mailto:secretariat.eco.mons@helha.be"" target=""_blank"" rel=""noopener"">secretariat.eco.mons@helha.be</a></strong>" & _
                                " - " & _
                                "<strong><a style=""color: #FFFFFF; text-decoration: none;"" href=""tel:065%2040%2041%2044"" target=""_blank"" rel=""noopener"">065.40.41.44</a></strong>" & _
                            "</p>" & _
                        "</td>" & _
                    "</tr>" & _
                "</table>" & _
            "</body>" & _
            "</html>"
    Else
        Body = Body & vbCrLf & vbCrLf & _
            "HELHa mons" & vbCrLf & _
            "Chaussée de Binche, 159 7000 Mons" & vbCrLf & _
            "065.40.41.44" & vbCrLf & _
            "secretariat.eco.mons@ helha.be"
        
    End If
    
    With OutlookMail
        .To = SendTo
        .Subject = Subject
        
        If UCase(Layout) = "HTML" Then
            .HtmlBody = HtmlBody
        Else
            .Body = Body
        End If
        
        If AttachmentPath <> "" Then
            .Attachments.Add AttachmentPath
        End If
        
        If Not DisplayEmail Then
            .Send
        Else
            .Display
        End If
    End With
    
    Set OutlookMail = Nothing
    Set OutlookApp = Nothing
    
    SendEmail = True
End Function

