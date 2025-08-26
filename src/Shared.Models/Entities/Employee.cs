namespace Shared.Models.Entities;

public class Employee : BaseEntity
{
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string? PhoneNumber { get; set; }
    
    // Employment details
    public string Position { get; set; } = string.Empty;
    public string? Department { get; set; }
    public decimal? HourlyRate { get; set; }
    public decimal? Salary { get; set; }
    public DateTime HireDate { get; set; }
    public DateTime? TerminationDate { get; set; }
    
    // Status
    public bool IsActive { get; set; } = true;
    public string? Notes { get; set; }
    
    // Foreign keys
    public Guid GymChainId { get; set; }
    public Guid? GymFacilityId { get; set; } // Nullable if employee works at chain level
    
    // Navigation properties
    public virtual GymChain GymChain { get; set; } = null!;
    public virtual GymFacility? GymFacility { get; set; }
}