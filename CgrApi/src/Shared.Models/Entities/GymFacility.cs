namespace Shared.Models.Entities;

public class GymFacility : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string Address { get; set; } = string.Empty;
    public string City { get; set; } = string.Empty;
    public string State { get; set; } = string.Empty;
    public string ZipCode { get; set; } = string.Empty;
    public string? Country { get; set; } = "USA";
    
    // Contact information
    public string? PhoneNumber { get; set; }
    public string? Email { get; set; }
    
    // Operating hours
    public string? OperatingHours { get; set; }
    
    // Facility details
    public decimal? SquareFootage { get; set; }
    public int? MaxCapacity { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTime? OpeningDate { get; set; }
    
    // Foreign key
    public Guid GymChainId { get; set; }
    
    // Navigation properties
    public virtual GymChain GymChain { get; set; } = null!;
    public virtual ICollection<Amenity> Amenities { get; set; } = new List<Amenity>();
    public virtual ICollection<Employee> Employees { get; set; } = new List<Employee>();
}