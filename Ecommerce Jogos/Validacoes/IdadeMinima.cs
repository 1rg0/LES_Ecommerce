using System;
using System.ComponentModel.DataAnnotations;

namespace Ecommerce_Jogos.Validacoes
{
    public class IdadeMinima : ValidationAttribute
    {
        private readonly int _idadeMinima;
        public IdadeMinima(int idadeMinima)
        {
            _idadeMinima = idadeMinima;
        }
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            if (value == null)
            {
                return ValidationResult.Success;
            }

            if (value is DateTime birthDate)
            {
                var today = DateTime.Today;
                var age = today.Year - birthDate.Year;

                if (birthDate.Date > today.AddYears(-age))
                {
                    age--;
                }

                if (age < _idadeMinima)
                {
                    return new ValidationResult(ErrorMessage);
                }
            }
            else
            {
                return new ValidationResult("Formato de data inválido.");
            }

            return ValidationResult.Success;
        }
    }
}
