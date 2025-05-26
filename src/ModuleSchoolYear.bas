Attribute VB_Name = "ModuleSchoolYear"
' Calcule l'année scolaire en fonction de la date actuelle

Function SchoolYear(Optional ByVal Format As String = "[YEAR1] / [YEAR2]") As String
    Dim currentYear As Integer
    Dim nextYear As Integer
    Dim mois As Integer
    
    mois = Month(Date)
    currentYear = Year(Date)
    
    If mois >= 1 And mois <= 8 Then
        nextYear = currentYear
        currentYear = currentYear - 1
    Else
        nextYear = currentYear + 1
    End If
    
    SchoolYear = Replace(Replace(Format, "[YEAR1]", currentYear), "[YEAR2]", nextYear)
End Function
