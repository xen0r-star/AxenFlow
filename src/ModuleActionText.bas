Attribute VB_Name = "ModuleActionText"
' Cette fonction insère un texte spécifié à la position actuelle du curseur dans un contrôle TextBox
' Utilisé pour les textes dynamiques des e-mails

Function actionText(ByVal textAdd As String, ByVal TextBox As control)
    Dim position As Integer
    Dim textBefore As String
    Dim countLines As Integer
    
    
    position = TextBox.SelStart
    
    textBefore = Left(TextBox.text, position)
    countLines = (Len(textBefore) - Len(Replace(textBefore, vbCrLf, ""))) / 2
    
    position = position + countLines
    
    TextBox.text = Left(TextBox.text, position) & _
                        textAdd & _
                        Mid(TextBox.text, position + 1)
    
    TextBox.SelStart = position + 1
End Function
