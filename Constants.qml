pragma Singleton

import QtQuick

QtObject {
    readonly property int test: 5

    enum LogicMode {
        Default = 2,
        Eco,
        NextTrip
    }

    enum Error {
        None = 0,
        FiAc = 1,
        FiDc = 2,
        Phase = 3,
        Overvolt = 4,
        Overamp = 5,
        Diode = 6,
        PpInvalid = 7,
        GndInvalid = 8,
        ContactorStuck = 9,
        ContactorMiss = 10,
        StatusLockStuckOpen = 12,
        StatusLockStuckLocked = 13,
        FiUnknown = 14,
        Unknown = 15,
        Overtemp = 16,
        NoComm = 17,
        CpInvalid = 18
    }

    enum AccessControl {
        Open,
        Wait,
        EVCMS
    }

    enum ForceState {
        Neutral,
        Off,
        On
    }

    enum CarState {
        Unknown,
        Idle,
        Charging,
        WaitCar,
        Complete,
        Error
    }

    enum SchedulerControl {
        Disabled,
        Allow,
        Block,
        AllowFromGrid,
        BlockFromGrid
    }

    enum ModelStatus {
        ChargingBecauseNoChargeCtrlData,
        NotChargingBecauseOvertemperature,
        NotChargingBecauseAccessControl,
        ChargingBecauseForceStateOn,
        NotChargingBecauseForceStateOff,
        NotChargingBecauseScheduler,
        NotChargingBecauseEnergyLimit,
        ChargingBecauseAwattarPriceLow,
        ChargingBecauseNextTripTestLadung,
        ChargingBecauseNextTripNotEnoughTime,
        ChargingBecauseNextTrip,
        ChargingBecauseNextTripNoClock,
        ChargingBecausePvSurplus,
        ChargingBecauseFallbackV2Default,
        ChargingBecauseFallbackV2Scheduler,
        ChargingBecauseFallbackDefault,
        NotChargingBecauseFallbackV2Awattar,
        NotChargingBecauseFallbackEco,
        NotChargingBecauseFallbackNextTrip,
        ChargingBecauseCarCompatibilityKeepAlive,
        ChargingBecauseChargePauseNotAllowed,
        Reserved21DoNotUse,
        NotChargingBecauseSimulateUnplugging,
        NotChargingBecausePhaseSwitch,
        NotChargingBecauseMinPauseDuration,
        Reserved25DoNotUse,
        NotChargingBecauseError,
        NotChargingBecauseLoadManagementDoesntWant,
        NotChargingBecauseOcppDoesntWant,
        NotChargingBecauseReconnectDelay,
        NotChargingBecauseAdapterBlocking,
        NotChargingBecauseUnderfrequencyControl,
        NotChargingBecauseUnbalancedLoad,
        ChargingBecauseDischargingPvBattery,
        NotChargingBecauseGridMonitoring,
        NotChargingBecauseOcppFallback,
        NotChargingBecauseFloorDetected,
        NotChargingBecauseOcppInoperable
    }

    enum PhaseSwitchMode {
        Auto,
        Force_1,
        Force_3
    }
}
