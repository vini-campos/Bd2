create function verIdade(@dataNasc date)
returns nvarchar(50)
as
begin
	if (DATEADD(year, 18, @dataNasc) < GETDATE())
	begin
		return 'Maior de Idade'
	end
	return 'Menor de Idade'
end


select  dbo.verIdade('2006-01-11')