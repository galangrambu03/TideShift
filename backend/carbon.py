# ===============================
# EMISSION FACTORS (kg CO₂/unit)
# ===============================
EMISSION_FACTORS = {
    'carTravelKm': 0.20,                # 0.20 kg CO₂ per km by car
    'showerTimeMinutes': 0.15,          # 0.15 kg CO₂ per minute of shower
    'electronicTimeHours': 0.08,        # 0.08 kg CO₂ per hour of gadget use
    'packagedFood': 0.50,               # 0.50 kg CO₂ for eating packaged food
    'onlineShopping': 0.30,             # 0.30 kg CO₂ for online shopping
    'wasteFood': 0.40,                  # 0.40 kg CO₂ for wasting food
    'airConditioningHeating': 2.00,     # 2.00 kg CO₂ if using AC/heater
    'noDriving': -1.00,                 # -1.00 kg CO₂ saved by not driving
    'plantMealThanMeat': -0.50,         # -0.50 kg CO₂ saved by choosing plant-based meal
    'useTumbler': -0.20,                # -0.20 kg CO₂ saved by using tumbler
    'saveEnergy': -0.30,                # -0.30 kg CO₂ saved by saving electricity
    'separateRecycleWaste': -0.20       # -0.20 kg CO₂ saved by recycling
}

# =======================
# CATEGORY GROUP MAPPING
# =======================
CATEGORY_MAPPING = {
    'transport': ['carTravelKm', 'noDriving'],
    'energy': ['showerTimeMinutes', 'electronicTimeHours', 'airConditioningHeating', 'saveEnergy'],
    'food': ['packagedFood', 'wasteFood', 'plantMealThanMeat'],
    'others': ['onlineShopping', 'useTumbler', 'separateRecycleWaste']
}

# ========================================
# Function to calculate total emissions
# ========================================
def calculate_carbon_emissions(data):
    total = 0.0
    for key, factor in EMISSION_FACTORS.items():
        value = data.get(key)

        # Skip if value is missing
        if value is None:
            continue

        try:
            # If the value is boolean (e.g. checkboxes), use factor directly
            if isinstance(value, bool):
                total += factor if value else 0

            # Otherwise, multiply the value with its emission factor
            else:
                total += float(value) * factor

        except:
            # Skip invalid or non-convertible values silently
            continue

    # Ensure the total cannot be negative
    return max(total, 0.0)

# ========================================
# Function to classify the emission level
# TODO: Menyesuaikan threshold
# ========================================
def classify_level(total_kg):
    if total_kg < 5:
        return 0  # Low
    elif total_kg < 15:
        return 1  # Medium
    else:
        return 2  # High

