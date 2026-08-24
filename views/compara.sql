create function comparaNum(@num1 int, @num2 int)
returns nvarchar(500)
as
begin
	if (@num1 > @num2)
	begin
		return @num1;
	end
	if (@num1 < @num2)
	begin
		return @num2;
	end
	return 'Numeros iguais'
end

select dbo.comparaNum(57, 57)