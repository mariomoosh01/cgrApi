namespace Shared.Models.Entities;

public class Amenity : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string Category { get; set; } = string.Empty; // e.g., "Equipment", "Service", "Facility"
    public bool IsAvailable { get; set; } = true;
    public decimal? Cost { get; set; } // Cost to maintain/provide this amenity
    public string? MaintenanceSchedule { get; set; }
    
    // Foreign key
    public Guid GymFacilityId { get; set; }
    
    // Navigation property
    public virtual GymFacility GymFacility { get; set; } = null!;
}