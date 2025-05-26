VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "EventMatriExist"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public WithEvents TextBox As MSForms.TextBox
Attribute TextBox.VB_VarHelpID = -1

' Vérifie si le matricule saisi existe dans la feuille "Etudiants" (doit être valide et commencer par "LA")
' Si trouvé, affiche le nom et prénom associés, sinon affiche "Inconnue"
' Met à jour la couleur du texte en fonction de la validité du matricule

Public Sub verifyMatriExist()
    Dim ws As Worksheet
    Dim control As control
    Dim name As String
    Dim firstName As String
    Dim position As Integer

    Set ws = ThisWorkbook.Sheets("Etudiants")
    
    If Len(TextBox.value) <> 8 Or Left(TextBox.value, 2) <> "LA" Then
        TextBox.ForeColor = &H3737B0
        
        name = "Inconnue"
        firstName = "Inconnue"
    Else
        On Error Resume Next
            position = Application.WorksheetFunction.Match(TextBox.value, ws.Range("A:A"), 0)
        On Error GoTo 0
        
        If position <> 0 Then
            TextBox.ForeColor = &HFFFFFF
            
            name = Trim(ws.Cells(position, 2).value)
            firstName = Trim(ws.Cells(position, 3).value)
        Else
            TextBox.ForeColor = &H3737B0
            
            name = "Inconnue"
            firstName = "Inconnue"
        End If
    End If
    
    On Error Resume Next
        Set control = Main.Controls(TextBox.Parent.name).Controls("textBox_" & CInt(Split(TextBox.name, "_")(1)) & "_3")
        control.text = name
        control.ForeColor = &HFFFFFF
    On Error GoTo 0
    
    On Error Resume Next
        Set control = Main.Controls(TextBox.Parent.name).Controls("textBox_" & CInt(Split(TextBox.name, "_")(1)) & "_4")
        control.text = firstName
        control.ForeColor = &HFFFFFF
    On Error GoTo 0
End Sub

Private Sub TextBox_Change()
    verifyMatriExist
End Sub



