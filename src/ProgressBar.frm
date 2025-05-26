VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} ProgressBar 
   Caption         =   "Progression"
   ClientHeight    =   5136
   ClientLeft      =   108
   ClientTop       =   456
   ClientWidth     =   7128
   OleObjectBlob   =   "ProgressBar.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "ProgressBar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' Interface pour la barre de progression
Dim viewDetails As Boolean
Dim cancelRequested As Boolean

Sub progress(ByVal i As Integer, ByVal max As Integer)
    ProgressBar.Text1.Caption = "Fichier " & i & " / " & max
    ProgressBar.Text2.Caption = Round((i / max) * 100, 0) & "% Complété"
    ProgressBar.Bar.Width = Round((318 / 100) * ((i / max) * 100), 0)
    
    DoEvents 'update the userform
End Sub

Sub addInfo(ByVal text As String)
    ProgressBar.TextInfo.text = ProgressBar.TextInfo.text + vbCrLf + text
    
    ProgressBar.TextInfo.SelStart = Len(ProgressBar.TextInfo.text)
    ProgressBar.TextInfo.SelLength = 0
    ProgressBar.TextInfo.SetFocus
End Sub

Sub clearInfo()
    viewDetails = True
    cancelRequested = False
    ButtonCancel.BackColor = &H3737B0
    ProgressBar.TextInfo.text = ""
    ProgressBar.TextInfo.SelStart = Len(ProgressBar.TextInfo.text)
End Sub

Private Sub ButtonCancel_Click()
    ButtonCancel.BackColor = &H808080
    cancelRequested = True
End Sub

Private Sub ButtonDetail_Click()
    viewDetails = Not viewDetails
    
    If viewDetails Then
        Me.Height = 285  ' Hauteur avec détails
    Else
        Me.Height = 150  ' Hauteur sans détails
    End If
End Sub

Public Property Get GetCancelRequested() As Boolean
    GetCancelRequested = cancelRequested
End Property
