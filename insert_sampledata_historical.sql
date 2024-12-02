INSERT INTO public.historical_lessons (
    lesson_id,
    student_name,
    student_email,
    lesson_type,
    genre,
    instrument,
    lesson_price,
    time
)
SELECT
    l.lesson_id,
    s.name AS student_name,
    s.email AS student_email,
    CASE 
        WHEN gl.lesson_id IS NOT NULL THEN 'Group'
        WHEN il.lesson_id IS NOT NULL THEN 'Individual'
        WHEN el.lesson_id IS NOT NULL THEN 'Ensemble'
    END AS lesson_type,
    el.genre AS genre,
    CASE 
        WHEN gl.lesson_id IS NOT NULL THEN gl.instrument_type
        WHEN il.lesson_id IS NOT NULL THEN il.instrument_type
        ELSE NULL
    END AS instrument,
    ps.price AS lesson_price,
    l.time AS time  -- Use 'time' instead of 'lesson_date'
FROM
    public.student_lesson sl
    JOIN public.lesson l ON l.lesson_id = sl.lesson_id
    LEFT JOIN public.student s ON s.student_id = sl.student_id
    LEFT JOIN public.individuallesson il ON il.lesson_id = l.lesson_id
    LEFT JOIN public.grouplesson gl ON gl.lesson_id = l.lesson_id
    LEFT JOIN public.ensemblelesson el ON el.lesson_id = l.lesson_id
    LEFT JOIN public.pricingscheme ps ON ps.pricing_scheme_id = l.pricing_scheme_id
WHERE
    l.time IS NOT NULL;
