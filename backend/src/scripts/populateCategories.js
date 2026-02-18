require('dotenv').config({ path: 'backend/.env' });
const mongoose = require('mongoose');
const Category = require('../models/Category');

const categories = [
    {
        name: { en: 'Mechanic', am: 'ሜካኒክ' },
        icon: 'construction',
        subCategories: [
            { 
                name: { en: 'Oil Cars', am: 'በዘይት የሚሰሩ መኪናዎች' },
                subCategories: [
                    { name: { en: 'Radiator Mechanic', am: 'የራዲያተር መካኒክ' } },
                    { name: { en: 'Motor Mechanic', am: 'የሞተር መካኒክ' } },
                    { name: { en: 'Electrical Mechanic', am: 'የኤሌክትሪክ መካኒክ' } },
                ]
            },
            {
                name: { en: 'Electric Cars', am: 'የኤሌክትሪክ መኪናዎች' },
                subCategories: [
                    { name: { en: 'Electric Car Mechanic', am: 'የኤሌክትሪክ መኪና መካኒክ' } }
                ]
            }
        ],
    },
    {
        name: { en: 'Dish and DSTV Installation', am: 'የዲሽ እና ዲኤስቲቪ ገጠማ' },
        icon: 'satellite_alt',
        subCategories: [
            { name: { en: 'Dish Installation and Maintenance', am: 'የዲሽ ገጠማ እና ጥገና' } },
            { name: { en: 'Channel Configuration', am: 'የቻናል ማስተካከያ' } },
            { name: { en: 'DSTV Installation', am: 'የዲኤስቲቪ ገጠማ' } },
        ],
    },
    {
        name: { en: 'Electrician', am: 'ኤሌክትሪሺያን' },
        icon: 'bolt',
        subCategories: [
            { name: { en: 'Full House Installation and Maintenance', am: 'የሙሉ ቤት ገጠማ እና ጥገና' } },
            { name: { en: 'Install Socket and Switch', am: 'ሶኬት እና ማብሪያ ማጥፊያ ገጠማ' } },
            { name: { en: 'Install LED Lamp', am: 'ኤልኢዲ አምፖል ገጠማ' } },
        ],
    },
    {
        name: { en: 'Plumber', am: 'የቧንቧ ሰራተኛ' },
        icon: 'plumbing',
        subCategories: [
            { name: { en: 'Water Pipe Installation and Maintenance', am: 'የውሃ ቧንቧ ገጠማ እና ጥገና' } },
            { name: { en: 'Sewerage Line Installation and Maintenance', am: 'የፍሳሽ መስመር ገጠማ እና ጥገና' } },
            { name: { en: 'Kitchen and Toilet Accessories Installation and Maintenance', am: 'የወጥ ቤት እና ሽንት ቤት እቃዎች ገጠማ እና ጥገና' } },
            { name: { en: 'Opening Closed Sewerage Tubes', am: 'የተዘጉ የፍሳሽ ቱቦዎችን መክፈት' } },
            { name: { en: 'Pressure Test', am: 'የግፊት ምርመራ' } },
        ],
    },
    {
        name: { en: 'Electronic Devices Repair', am: 'የኤሌክትሮኒክስ እቃዎች ጥገና' },
        icon: 'electrical_services',
        subCategories: [
            { name: { en: 'Enjera Baking Machine', am: 'የእንጀራ ምጣድ' } },
            { name: { en: 'Stove', am: 'ስቶቭ' } },
            { name: { en: 'Oven', am: 'ኦቨን' } },
            { name: { en: 'Coffee Grinders', am: 'የቡና መፍጫ' } },
            { name: { en: 'Juice and Onion Grinders', am: 'የጁስ እና የሽንኩርት መፍጫ' } },
            { name: { en: 'Boilers', am: 'ቦይለር' } },
            { name: { en: 'Refrigerator', am: 'ፍሪጅ' } },
        ],
    },
    {
        name: { en: 'Painter', am: 'ቀቢ' },
        icon: 'format_paint',
        subCategories: [
            { name: { en: 'Full House Painters', am: 'የሙሉ ቤት ቀቢዎች' } },
        ],
    },
    {
        name: { en: 'Gypsum', am: 'ጂፕሰም' },
        icon: 'architecture',
        subCategories: [
            { name: { en: 'Chak', am: 'ቻክ' } },
            { name: { en: 'Frame', am: 'ፍሬም' } },
        ],
    },
    {
        name: { en: 'Drilling Walls', am: 'ግድግዳ መብሳት' },
        icon: 'power',
        subCategories: [
            { name: { en: 'TV and Receiver Mount', am: 'የቲቪ እና ሪሲቨር መግጠም' } },
            { name: { en: 'Curtain Mount', am: 'የመጋረጃ መግጠም' } },
        ],
    },
    {
        name: { en: 'Rooftop Leakage', am: 'የጣሪያ ፍሳሽ' },
        icon: 'roofing',
        subCategories: [
            { name: { en: 'Leakage Maintenance', am: 'የፍሳሽ ጥገና' } },
        ],
    },
];

const seedCategories = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('MongoDB Connected');

        await Category.deleteMany({});
        console.log('Cleared existing categories.');

        const createCategory = async (cat, parent = null, ancestors = []) => {
            const newCategory = new Category({
                name: cat.name,
                icon: cat.icon,
                parent,
                ancestors,
            });
            await newCategory.save();

            if (cat.subCategories) {
                const newAncestors = [...ancestors, newCategory._id];
                for (const subCat of cat.subCategories) {
                    await createCategory(subCat, newCategory._id, newAncestors);
                }
            }
        };

        for (const cat of categories) {
            await createCategory(cat);
        }

        console.log('Categories seeded successfully!');
    } catch (error) {
        console.error('Error seeding categories:', error);
    } finally {
        mongoose.connection.close();
    }
};


seedCategories();