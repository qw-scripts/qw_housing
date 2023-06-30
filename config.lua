Config = {}

Config.MinZ = 45.0

Config.Shells = {
    'shell_warehouse1',
    'shell_warehouse2',
    'shell_warehouse3',
    'shell_store1',
    'shell_store2',
    'shell_store3',
    'shell_office1',
    'medium_housing1_k4mb1'
}

Config.ShellData = {
    ['shell_warehouse1'] = {
        exit = vec4(-8.480194, 0.211365, -0.949245, 271.971619)
    },
    ['shell_warehouse2'] = {
        exit = vec4(-12.336395, 5.568604, -2.059042, 275.846954)
    },
    ['shell_warehouse3'] = {
        exit = vec4(2.526672, -1.682983, -0.942857, 87.265800)
    },
    ['shell_store1'] = {
        exit = vec4(-2.800449, -4.485840, -0.619572, 358.204010)
    },
    ['shell_store2'] = {
        exit = vec4(-0.837524, -4.922119, -1.153347, 1.971105)
    },
    ['shell_store3'] = {
        exit = vec4(-0.039734, -7.766663, -0.301029, 356.620819)
    },
    ['shell_office1'] = {
        exit = vec4(1.258789, 5.024536, -0.725484, 178.357941)
    },
    ['medium_housing1_k4mb1'] = {
        exit = vec4(-0.482040, 7.362061, -0.569901, 177.268402)
    }
}

Config.PropSettings = {
    ['prop_ld_int_safe_01'] = {
        type = 'storage',
        slots = 45,
        weight = 10000,
    }
}
---

QBCore = exports['qb-core']:GetCoreObject()