VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "EventSelectNote"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public WithEvents CommandButton As MSForms.CommandButton
Attribute CommandButton.VB_VarHelpID = -1

' Lors du clic sur le bouton, sélectionne la ligne correspondante
' dans la feuille "GrillePoints" en fonction du nom du bouton

Private Sub commandButton_Click()
    Dim line As String
    Dim ws As Worksheet
    
    line = Int(Split(CommandButton.name, "_")(1)) + 3
    
    Set ws = Worksheets("GrillePoints")
    
    ws.Activate
    ws.Rows(line).Select
End Sub





