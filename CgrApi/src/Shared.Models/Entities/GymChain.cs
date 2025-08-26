namespace Shared.Models.Entities;

public class GymChain : BaseEntity
{
    public string BusinessName { get; set; } = string.Empty;
    public string? BusinessDescription { get; set; }
    public string? BusinessLicense { get; set; }
    public string? TaxId { get; set; }
    
    // Business contact information
    public string BusinessEmail { get; set; } = string.Empty;
    public string? BusinessPhone { get; set; }
    public string? Website { get; set; }
    
    // Business address (headquarters)
    public string? HeadquartersAddress { get; set; }
    public string? City { get; set; }
    public string? State { get; set; }
    public string? ZipCode { get; set; }
    public string? Country { get; set; } = "USA";
    
    public bool IsActive { get; set; } = true;
    public DateTime? EstablishedDate { get; set; }
    
    // Foreign key
    public Guid ManagerProfileId { get; set; }
    
    // Navigation properties
    public virtual ManagerProfile ManagerProfile { get; set; } = null!;
    public virtual ICollection<GymFacility> GymFacilities { get; set; } = new List<GymFacility>();
    public virtual ICollection<Employee> Employees { get; set; } = new List<Employee>();
}